class OpportunitiesController < ApplicationController
  before_action :authenticate_user!, except: [:add_trial, :join_class]
  before_action :authorize_employee, except: [:add_trial, :join_class]

  def analytics
  end

  # GET /opportunities
  # GET /opportunities.json
  def index
    @opportunities = Opportunity.includes(:user, :student, offering: [:location, :course]).active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opportunities }
    end
  end

  def status_index
    @status = params[:status]
    @location = Location.find params[:location_id]
    @opportunities = Opportunity.where(status: params[:status], location_id: params[:location_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opportunities }
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    @opportunity = Opportunity.find(params[:id])

    if @opportunity.versions
      @versions = @opportunity.versions
    else
      @versions = []
    end

    @new_student = Student.new
    @new_parent = User.new
    @opp_student = @opportunity.student if @opportunity.student
    @generated_password = Devise.friendly_token.first(8)
    set_active_offerings
    set_statuses

    if @opportunity.promotion_sent && @opportunity.promotion_id
      @promotion_name = Opportunity::PROMOTIONS.select {|array| array[1] == @opportunity.promotion_id}[0]
      @promotion_name = @promotion_name[0]
    else
      # Opportunity promotions
      @promotions = Opportunity::PROMOTIONS
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/new
  # GET /opportunities/new.json
  def new
    @opportunity = Opportunity.new
    set_parents
    set_active_offerings
    set_statuses

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity = Opportunity.find(params[:id])
    set_parents
    set_active_offerings
    set_statuses
    @statuses_without_won = @statuses
    @statuses_without_won.delete_at(7)
  end

  # POST /opportunities
  # POST /opportunities.json
  def create
    @opportunity = Opportunity.new(opportunity_params)

    if @opportunity.parent_name
      # Find possible users by searching for last name and email, removing duplicates
      @possible_users = User.where("last_name LIKE ? OR first_name LIKE ? OR email LIKE ?", "%#{@opportunity.parent_name.split.last}%", "%#{@opportunity.parent_name.split.last}%", "%#{@opportunity.parent_email}%").order(:last_name)
      @possible_users = @possible_users.uniq
    end

    respond_to do |format|
      if @opportunity.save
        if @opportunity.student
          format.html { redirect_to student_path(@opportunity.student), notice: 'Opportunity was successfully created.' }
          format.json { render json: @opportunity, status: :created, location: @opportunity }
          format.js
        else
          format.html { redirect_to root_url, notice: 'Opportunity was successfully created.' }
          format.json { render json: @opportunity, status: :created, location: @opportunity }
          format.js
        end
      else
        format.html { render action: "new" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /opportunities/1
  # PUT /opportunities/1.json
  def update
    @opportunity = Opportunity.find(params[:id])
    @parent = @opportunity.user
    @status = @opportunity.status
    set_parents
    set_active_offerings

    respond_to do |format|
      if @opportunity.update_attributes(opportunity_params)
        if @status.to_i == 8 #lost
          @opportunity.update_attribute :date_lost, Date.today
        elsif status.to_i == 4 #undecided
          @opportunity.update_attribute :undecided_date, Date.today
        elsif status.to_i == 2 #missed appointment
          @parent.missed_appointment
        end
        format.html { redirect_to opportunity_path(@opportunity), notice: 'Opportunity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to opportunities_url }
      format.json { head :no_content }
    end
  end

  def update_status
    @opportunity = Opportunity.find(params[:id])
    @parent = @opportunity.user
    @user_location = @opportunity.location
    @old_status = @opportunity.status
    @new_status = params[:status]
    @note = Note.new

    respond_to do |format|
      if @opportunity.update_status(@new_status.to_i)
        format.js
      end
    end
  end

  def by_status
    # @opportunities = Opportunity.where(status: params[:status])
    @user_location = Location.find(params[:location_id])
    @status = params[:status]
    @note = Note.new

    respond_to do |format|
      format.js
    end
  end

  def add_parent
    @opportunity = Opportunity.find(params[:id])
    @user = User.find(params[:user_id])

    # Workflow takes user to possible students to add to opportunity once parent is added.
    @possible_students = Student.where("last_name LIKE ? OR first_name LIKE ? OR first_name LIKE ?", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.first}%").order(:last_name ).uniq

    respond_to do |format|
      if @opportunity.update_attribute(:user_id, params[:user_id].to_i)
        format.js
      end
    end
  end

  def add_student
    @opportunity = Opportunity.find(params[:id])
    @student = Student.find(params[:student_id])

    respond_to do |format|
      if @opportunity.update_attribute(:student_id, params[:student_id].to_i)
        format.js
      end
    end
  end

  def add_to_class
    @opportunity = Opportunity.find(params[:registration][:opportunity_id])
    @registration = Registration.new(registration_params)
    @student = Student.find(params[:registration][:student_id])
    @parent = @student.user

    respond_to do |format|
      #check to see that a student and an offering are associated with the opportunity
      if @opportunity.student && @opportunity.offering
        if @registration.save
          # Add parent to new customer sequence.
          Infusionsoft.contact_add_to_group(@parent.infusion_id, 1648) if @parent.infusion_id

          if @registration.start_date <= Date.today
            @registration.update_attribute :status, 1
            @registration.student.user.update_attribute :active, true
          end

          # Update opportunity attributes
          @opportunity.update_attribute :status, 7 # set opportunity to won
          @opportunity.update_attribute :date_won, Date.today # set date won date
          if @registration.payment_information_later
            # For when billing information will be collected at first class.
            add_payment_note # add note to collect billing info at first class
            format.html { redirect_to student_path(@student), notice: 'Registration was successfully created. A note has been added to parent\'s account to collect payment information on start date.' }
            format.json { render json: @registration, status: :created, location: @registration }
          else
            if current_company.infusionsoft_integration?
              format.html { redirect_to infusion_pages_subscription_path(userId: @parent.id), notice: 'Registration was successfully created.' }
              format.json { render json: @registration, status: :created, location: @registration }
            else
              format.html { redirect_to student_path(@student), notice: 'Registration was successfully created.' }
              format.json { render json: @registration, status: :created, location: @registration }
            end
          end
        else
          format.html { render action: "new" }
          format.json { render json: @registration.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @opportunity.student, notice: 'Student and offering must be added in order to add student to a class. Click the edit button and make sure the opportunity is updated before adding to class.' }
        format.json { head :no_content }
      end
    end
  end

  def add_trial
    opportunity = Opportunity.new(opportunity_params)
    opportunity.status = 3 # sets opportunity status to 'trial'
    opportunity.interest_level = 2

    if opportunity.save
      user = check_add_user_with_email(opportunity) # add user to opportunity or create and add if not
      NotificationMailer.trial_confirmation(opportunity).deliver # trial registration confirmation
      send_slack_notification(opportunity) # send notification to Slack

      redirect_to "http://www.mathplusacademy.com/trial-scheduled/"
    end

    #add note with actionable item
    note = user.notes.build({
      content: "#{user.first_name} has scheduled a trial. Please create or link this to a student account.",
      user_id: user.class.system_admin_id,
      location_id: opportunity.location_id,
      action_date: Date.today})

    note.save!
  end

  def appointment_completed
    set_opportunity
  end

  def attended_trial
    set_opportunity

    if @student
      # change opportunity status to 'undecided'
      if @opportunity.update_attributes attended_trial: true, status: 4
        redirect_to root_url(subdomain: current_company.subdomain), notice: "#{@student.full_name} has attended their trial. Moved opportunity to undecided."

        # note account to indicate student attended trial
        @note = @parent.notes.build({content: "#{@student.full_name} has attended their trial. Please follow-up to confirm enrollment.  An email has also been sent to inquire about enrollment. Moved opportunity to undecided.", user_id: current_user.id, action_date: Date.today, location_id: @parent.location_id})
        @note.save

        # send thank you note
        NotificationMailer.trial_attended(@opportunity).deliver
      end
    else
      redirect_to root_url(subdomain: current_company.subdomain), flash: { alert: "You must and a student to this opportunity, before marking their trial as attended."}
    end
  end

  def join_class
    opportunity = Opportunity.find(params[:opportunity_id])
    student = opportunity.student
    parent = student.user
    joining_class = params[:joining]

    if joining_class
      # add note to parent's account to indicate whether they are joining class or not.
      note = parent.notes.build({content: "#{student.full_name} has attended their trial and would like to join #{opportunity.offering.offering_name}", user_id: User.system_admin_id, action_date: Date.today, location_id: parent.location_id})

      note.save

      redirect_to thank_you_path(action: "joining")
    else
      # add note to parent's account to indicate whether they are joining class or not.
      note = parent.notes.build({content: "#{student.full_name} has attended their trial and has chose not #{opportunity.offering.offering_name}", user_id: User.system_admin_id, action_date: Date.today, location_id: parent.location_id})

      note.save

      redirect_to thank_you_path(action: "not_joining")
    end
  end

  def change_trial_date
    @opportunity = Opportunity.find(params[:id])
  end

  def missed_trial
    set_opportunity

    if @student
      if @opportunity.update_attributes missed_trial: true, status: 4
        redirect_to root_url(subdomain: current_company.subdomain), notice: "#{@student.full_name} has missed their trial."
        @note = @parent.notes.build({content: "#{@student.full_name} missed trial. Call to reschedule trial.", user_id: @parent.class.system_admin_id, action_date: Date.today, location_id: @parent.location_id})
        @note.save
      end
    else
      redirect_to root_url(subdomain: current_company.subdomain), flash: { alert: "You must add a student to this opportunity, before marking their trial as missed."}
    end
  end

  def update_interest
    @opportunity = Opportunity.find(params[:id])

    respond_to do |format|
      if @opportunity.update_attribute :interest_level, params[:interest_level].to_i
        format.js
      end
    end
  end

  def data
    data = Opportunity.report_data

    respond_to do |format|
      format.json {
        render :json => data
      }
    end
  end

  def aging_data
    data = Opportunity.aging_data

    respond_to do |format|
      format.json {
        render :json => data
      }
    end
  end

  private
    def set_opportunity
      @opportunity = Opportunity.find(params[:id])
      @student = Student.find(@opportunity.student_id) if @opportunity.student_id
      @parent = @opportunity.user
    end

    def set_active_offerings
      @active_offerings = Offering.order(:course_id, :location_id, :day_number).includes(:course, :location).where("active = ?", true)
    end

    def set_parents
      @parents = User.where(:role => "Parent").order('last_name asc')
    end

    def set_statuses
      @statuses = Opportunity::STATUSES.zip((0..8).to_a)
      @statuses_without_won = @statuses
      @statuses_without_won.delete_at(7)
    end

    def add_payment_note
      @note = @parent.notes.build({content: "#{@student.full_name} is starting today and we may not have payment information. Please check to see if payment information is on file. If not, collect at first class.", user_id: current_user.id, action_date: @registration.start_date, location_id: @parent.location_id})
      @note.save
    end

    def check_add_user_with_email(opportunity)
      @opportunity = opportunity
      @user = User.find_by_email(@opportunity.parent_email.downcase) #check to see if user account exists via email

      if !@user
        #create user account if no account found
        @generated_password = Devise.friendly_token.first(8) # password for new user
        @user = User.create!(
                      first_name:               @opportunity.parent_name.split.first,
                      last_name:                @opportunity.parent_name.split.last,
                      location_id:              @opportunity.location_id,
                      email:                    @opportunity.parent_email,
                      password:                 @generated_password,
                      active:                   false,
                      subdomain:                cuurent_company.subdomain,
                      role:                     "Parent")
      end

      @opportunity.update_attribute :user_id, @user.id #update opportunity with existing user_id
      @user
    end

    def opportunity_params
      params.require(:opportunity).permit(:admin_id, :attended_trial, :offering_id, :possible_restart_date,
                                          :registration_id, :status, :student_id, :trial_date, :appointment_date, :parent_name, :course_id, :location_id, :student_name, :date_won, :date_lost, :source, :title, :parent_phone, :parent_email, :interest_level, :other_source, :undecided_date, :user_id, :promotion_sent, :promotion_id, :missed_trial)
    end

    def registration_params
      params.require(:registration).permit(:admin_id, :attended_first_class, :attended_trial, :end_date, :hold_date, :offering_id, :start_date, :status, :student_id, :trial_date, :hold_id, :switch_id, :switch, :restart_date, :drop_reason, :payment_information_later)
    end

    def send_slack_notification(opportunity)
      HTTParty.post("https://hooks.slack.com/services/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",
      {:body => {text: "#{opportunity.offering_name}\nDate: #{opportunity.trial_date.strftime("%b %d, %Y")}",
                  username: "Trial Scheduled",
                  icon_emoji: ":smiley:",}.to_json,
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                  })
    end
end
