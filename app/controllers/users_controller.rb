class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:infusion_request, :appointment_request]
  skip_before_filter :verify_authenticity_token, only: [:infusion_request, :appointment_request, :missed_appointments, :confirmation_opt_out]

  respond_to :html

  rescue_from Rack::Timeout::RequestTimeoutException, :with => :rescue_from_timeout

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:location)
    @active_users = User.active.includes(:location)
    @parents = User.where("role=?", "Parent").includes(:location)
    @active_parents = User.where("role = ? AND active = ?", "Parent", true)
    @active_employees = User.where("role != ? AND active = ?", "Parent", true)
    @active_employees_emails = []
    @active_employees.each {|ae| @active_employees_emails << ae.email + ","}

    if current_user.employee?

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
        if params[:email]
          format.csv { send_data @active_parents.parent_email_to_csv }
        else
          format.csv { send_data @users.to_csv }
        end
      end
    else
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    set_user
    @note_user = @user
    @note = Note.new
    if @user.parent? && current_user.admin?
      @new_student = Student.new
      @parent_opportunities = @user.opportunities
    end

    if current_user.employee? || current_user.id == @user.id
      ########
      count = 0
      begin
        if @user.role == "Parent" && @user.infusion_id != nil
          # retrieve subscriptions for contact
          @active_subscription = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => @user.infusion_id, :Status => "Active"}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
          # get active subscriptions from Infusiosoft
          subscriptions = Infusionsoft.data_query('CProgram', 50, 0, {:Status => "1"}, [:Id, :ProgramName, :DefaultPrice, :DefaultCycle, :DefaultFrequency] )
          # attach subscription plan names
          @active_subscription.each do |i|
            subscriptions.each do |j|
              if i["ProgramId"].to_i == j["Id"].to_i
                i["ProgramName"] = j["ProgramName"]
              end
            end
          end
     # get invoices and display recent ones
          @invoices = Infusionsoft.data_query_order_by('Invoice', 10, 0, {:ContactId => @user.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
          @invoices.each do |i|
            if i["PayStatus"] == 0
              i["Status"] = "<span class='label label-important'>Unpaid</span>"
            elsif i["RefundStatus"] == 1
              i["Status"] = "<span class='label label-warning'>Partial Refund</span>"
            elsif i["RefundStatus"] == 2
              i["Status"] = "<span class='label label-warning'>Full Refund</span>"
            else
              i["Status"] = "<span class='label label-success'>Paid</span>"
            end
          end
        end
      ########
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @user }
        end
      rescue
        if count < 3
          count = count + 1
          retry
        end
      end
    else
    redirect_to root_path
    end
  end

  def my_account
    @user = User.includes(:students).find(params[:id])
    count = 0
    begin
      results = Infusionsoft.contact_load(@user.infusion_id, [:Id, :FirstName, :LastName, :ContactType, :Email, :Phone1Type, :Phone1, :Phone2Type, :Phone2, :StreetAddress1, :PostalCode, :City, :State])
      if results.empty?
      else
        @infusion_info = OpenStruct.new(results)
      end
    rescue
      if count < 3
        count += 1
        retry
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @generated_password = Devise.friendly_token.first(8)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    set_user
    ########
    # If Parent has no Infusionsoft Id, then search for matches in Infusionsoft and provide ids
    @contacts = nil
    if @user.role == "Parent" && @user.infusion_id == nil
      # get contacts with matching last name
      @contacts = Infusionsoft.data_query_order_by('Contact', 50, 0, {:LastName=> @user.last_name}, [:Id, :FirstName, :LastName, :ContactType, :Email], :FirstName, true)
      # data clean up - blank out missing names, create ContactId = Id
      @contacts.each do |i|
        i["FirstName"] == nil ? i["FirstName"]="" : nil
        i["ContactId"] = i["Id"]
      end
    end
    ########
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user].except!(:send_password_link, :opportunity_id))

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.js
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_from_opportunity
    @opportunity = Opportunity.find(params[:user][:opportunity_id])
    @user = User.new(params[:user].except!(:send_password_link, :opportunity_id))
    # Workflow takes user to possible students to add to opportunity once parent is added.
    @possible_students = Student.where("last_name LIKE ? OR first_name LIKE ? OR first_name LIKE ?", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.first}%").order(:last_name ).uniq

    respond_to do |format|
      if @user.save!
        @opportunity.update_attribute :user_id, @user.id
        format.js
        format.json { render json: @user, status: :created, location: @user }
      else
        format.js
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    set_user

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def deactivate
    set_user

    @user.deactivate

    respond_to do |format|
      format.html { redirect_to users_url(users: :parents), notice: "#{@user.full_name} and their student(s) have been deactivated." }
      format.json { head :no_content }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    set_user

    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def import
    User.import(params[:file])
    redirect_to users_path, notice: "Users imported."
  end

  def password_reset
    set_user

    if @user.send_reset_password_instructions
      respond_to do |format|
        format.html { redirect_to @user, notice: "Password reset instructions sent." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @user, notice: "Error sending instructions." }
        format.json { head :no_content }
      end
    end
  end

  def send_hold_form
    set_user

    respond_to do |format|
      if AdminMailer.hold_form(@user).deliver

        @note1 = @user.notes.build({
          content: "Hold form sent.",
          user_id: current_user.id})

        @note1.save!
        format.html { redirect_to @user, notice: "Hold form sent." }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: "Error sending hold form." }
        format.json { head :no_content }
      end
    end
  end

  def send_termination_form
    set_user

    respond_to do |format|
      if AdminMailer.termination_form(@user).deliver

        @note1 = @user.notes.build({
          content: "Termination form sent.",
          user_id: current_user.id})
        @note1.save!

        format.html { redirect_to @user, notice: "Termination form sent." }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: "Error sending termination form." }
        format.json { head :no_content }
      end
    end
  end

  def infusion_request
    @parent = User.where(infusion_id: params["Id"].to_i).first
    @promotion_id = params["Promotion"].to_i if params["Promotion"]
    @promotion_id = params["promotion"].to_i if params["promotion"]
    @promotion_name = Opportunity::PROMOTIONS.select {|array| array[1] == @promotion_id}[0]
    @promotion_name = @promotion_name[0]

    if @parent
      @location = @parent.location
      @user = User.find(1)
      AdminMailer.contact_request(@parent, @user).deliver
      @note = @parent.notes.build({user_id: @user.id, content: "Call #{@parent.full_name} about #{@promotion_name} promotion.", action_date: Date.today, location_id: @location.id })
      @note.save
    else
    end
    render nothing: true
  end

  def year_end_promotion
    set_user
    if @user && Rails.env.production?
      respond_to do |format|
        if Infusionsoft.contact_add_to_group(@user.infusion_id, 1784) #adds tag: "year end promotion"
          @user.update_attribute :year_end_campaign, true
          format.json { head :no_content }
        end
      end
    end
  end

  def promotion
    @user = current_user
    @promotion_id = params[:promotion][:id].to_i
    @parent = User.find(params[:promotion][:user_id].to_i)
    @opportunity = Opportunity.find(params[:promotion][:opportunity_id].to_i)
    @promotion_name = Opportunity::PROMOTIONS.select{|array| array[1] == @promotion_id}[0][0]

    respond_to do |format|
      if data = Infusionsoft.contact_add_to_group(@parent.infusion_id, @promotion_id)
        #update opportunity to record promotion_id and that promotion has been sent.
        @opportunity.update_attributes promotion_sent: true, promotion_id: @promotion_id

        #add note to user's account to show that campaign has started
        @note = @parent.notes.build({user_id: @user.id, content: "Promotion #{@promotion_name} sent.", opportunity_id: @opportunity.id })
        @note.save

        format.html { redirect_to @opportunity, notice: "Promotion #{@promotion_name} started" }
      end
    end
  end

  def appointment_reschedule_request
    @parent = User.find_by_infusion_id(params["Id"].to_i)

    if @parent
      @location = @parent.location
      @user = User.find(1)
      AdminMailer.contact_request(@parent, @user).deliver
      @note = @parent.notes.build({user_id: @user.id, content: "#{@parent.full_name} would like to reschedule their appointments.", action_date: Date.today, location_id: @location.id })
      @note.save
    else
    end
  end

  def appointment_request
    response = request.body.read
    appointment = JSON.parse(response)
    puts appointment
    @appointment_request = AppointmentRequest.create(data: response)
    @parent = User.find_by_check_appointments_id( appointment['client']['clientId'] )
    # if a Parent already has CheckAppointments Id associated with record save appointment.
    if @parent
      # Check and see if appointment exists in database before create to see if might be an update.
      if @appointment = Appointment.find_by_calendarId(appointment['calendarid'])
        #update information of existing appointment
        @appointment.update_attributes({
          reasonId:      appointment['reason']['reasonId'],
          visitMinutes:  appointment['reason']['visitMinutes'],
          time:          DateTime.parse(appointment['appointmentDateTimeClient']),
          note:          appointment['note'],
          status:        appointment['status']})
      else
        apt_time = appointment['appointmentDateTimeClient']

        if apt_time
          apt_time = DateTime.parse(apt_time)
        else
          apt_time = DateTime.now
        end

        # Appointment is not in DB, create new appointment record.
        @appointment = Appointment.create!(
          clientId:      appointment['client']['clientId'],
          calendarId:    appointment['calendarid'],
          locationId:    appointment['location']['locationId'],
          reasonId:      appointment['reason']['reasonId'],
          visitMinutes:  appointment['reason']['visitMinutes'],
          time:          apt_time,
          user_id:       @parent.id,
          note:          appointment['note'],
          status:        appointment['status']
        )
        # add information if appointment is for hw help
        if appointment['reason']['reasonId'] == 37118
          @appointment.update_attributes({
            hwHelpChild:   appointment['customField1'],
            hwHelpClass:   appointment['customField2'],
            hwHelpReason:  appointment['customField3']})
        end

        # add location information
        @appointment.update_location(appointment['location']['locationId'])

        # create note if scheduling assessment
        if appointment['reason']['reasonId'] == 37117
          #build note content
          content = add_note_content(appointment, @appointment)

          note = @parent.notes.build({
            content: content,
            user_id: @parent.system_admin_id,
            location_id: @appointment.location_id,
            action_date: Date.today})

          note.save!

          #send notification to slack
          #payload={"text": "A very important thing has occurred! <https://alert-system.com/alerts/1234|Click here> for details!"}
          slack_note = slack_note_content(appointment, @appointment)

          HTTParty.post("https://hooks.slack.com/services/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",
          {
            :body => {text: "Location: #{@appointment.location.name}\n #{slack_note}", username: "Assessment Scheduled", icon_emoji: ":smiley:",}.to_json,
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
          })
        end
      end
    # check to see if parent is in system, but has not had Check Appointments Id added to record
    elsif appointment['client']['emailAddress'] && (@parent_update_ca_id = User.find_by_email( appointment['client']['emailAddress'].downcase ))

      @parent_update_ca_id.update_attribute :check_appointments_id, appointment['client']['clientId']

      @appointment = Appointment.create!(
        clientId:      appointment['client']['clientId'],
        calendarId:    appointment['calendarid'],
        locationId:    appointment['location']['locationId'],
        reasonId:      appointment['reason']['reasonId'],
        visitMinutes:  appointment['reason']['visitMinutes'],
        time:          DateTime.parse(appointment['appointmentDateTimeClient']),
        user_id:       @parent_update_ca_id.id,
        note:          appointment['note'],
        status:        appointment['status']
        )
      # add information if appointment is for hw help
      if appointment['reason']['reasonId'] == 37118
        @appointment.update_attributes({
          hwHelpChild:   appointment['customField1'],
          hwHelpClass:   appointment['customField2'],
          hwHelpReason:   appointment['customField3']})
      end

      # add location information
      @appointment.update_location(appointment['location']['locationId'])
    else
      # User is not in system. Create user and add appointment.
      @generated_password = Devise.friendly_token.first(8) # password for new user

      if appointment['client']['emailAddress']
        if appointment['client']['emailAddress'].empty?
          email = "email#{SecureRandom.hex(3)}@mathplusacademy.com"
        else
          email = appointment['client']['emailAddress']
        end
      else
        email = "emailinvadlid#{SecureRandom.hex(3)}@mathplusacademy.com"
      end

      @parent = User.create!(
                    check_appointments_id:    appointment['client']['clientId'],
                    first_name:               appointment['client']['firstName'],
                    last_name:                appointment['client']['lastName'],
                    email:                    appointment['client']['emailAddress'],
                    phone:                    appointment['client']['cellPhone'],
                    password:                 @generated_password,
                    active:                   false,
                    role:                     "Parent")

      # Add location information to user
      if appointment['location']['locationId'] == 10935
        @parent.update_attribute :location_id, 1
      elsif appointment['location']['locationId'] == 10936
        @parent.update_attribute :location_id, 2
      elsif appointment['location']['locationId'] == 23402
        @parent.update_attribute :location_id, 3
      end

      # Add appointment to system
      @appointment = Appointment.create!(
        clientId:      appointment['client']['clientId'],
        calendarId:    appointment['calendarid'],
        locationId:    appointment['location']['locationId'],
        reasonId:      appointment['reason']['reasonId'],
        visitMinutes:  appointment['reason']['visitMinutes'],
        time:          DateTime.parse(appointment['appointmentDateTimeClient']),
        user_id:       @parent.id,
        note:          appointment['note'],
        status:        appointment['status']
        )

      # add location information
      @appointment.update_location(appointment['location']['locationId'])

      # create note if scheduling assessment
      if appointment['reason']['reasonId'] == 37117
        #build note content
        content = add_note_content(appointment, @appointment)

        @note1 = @parent.notes.build({
          content: content,
          user_id: @parent.system_admin_id,
          location_id: @parent.location_id,
          action_date: Date.today})

        @note1.save!

        #post to slack
        slack_note = slack_note_content(appointment, @appointment)

        HTTParty.post("https://hooks.slack.com/services/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",
        {
          :body => {text: "Location: #{@appointment.location.name}\n #{slack_note}", username: "Assessment Scheduled", icon_emoji: ":smiley:",}.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        })
      end
    end

    render nothing: true, status: 200
  end

  def confirmation_opt_out
    if params[:id]
      set_user

      if @user.update_attribute :confirmation_opt_out, true
        flash[:notice] = "We have updated your account and you will no longer receive
        confirmations via email. To change this you can go to your account settings."
      end

      redirect_to thank_you_url
    else
      redirect_to root_url
    end
  end

  def hide_badge_banner
    set_user

    if @user.update_attribute :hide_badge_banner, true
      redirect_to root_path
    end
  end

  def show_badge_banner
    set_user

    if @user.update_attribute :hide_badge_banner, false
      redirect_to root_path
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def rescue_from_timeout
      redirect_to :back, notice: 'Your request'
    end

    def add_note_content(appointment, app_obj)
      content = "<b>Please add #{'Opportunity'.pluralize(appointment['customField1'].to_i)}:</b> \n Number of students: #{appointment['customField1']}\n #{'Student'.pluralize(appointment['customField1'].to_i)}: #{appointment['customField2']} (#{appointment['customField3']})\n"

      # add student information to note it there are more than one students
      case appointment['customField1'].to_i
      when 2
        content = content + ", #{appointment['customField4'] if appointment['customField4']} (#{appointment['customField5'] if appointment['customField5']})\n"
      when 3
        content = content + ", #{appointment['customField4'] if appointment['customField4']} (#{appointment['customField5'] if appointment['customField5']}), #{appointment['customField6'] if appointment['customField6']} (#{appointment['customField7'] if appointment['customField7']}) \n"
      else

      end

      content = content + "Appointment: #{app_obj.time.strftime("%b %d,%l:%M%p")}\n"

      content = content + "Comments: #{appointment['customField9'] ? appointment['customField9'] : "No comments."}"

      content
    end

    def slack_note_content(appointment, app_obj)
      content = "Number of students: #{appointment['customField1']}\n #{'Student'.pluralize(appointment['customField1'].to_i)}: #{appointment['customField2']} (#{appointment['customField3']})\n"

      # add student information to note it there are more than one students
      case appointment['customField1'].to_i
      when 2
        content = content + ", #{appointment['customField4'] if appointment['customField4']} (#{appointment['customField5'] if appointment['customField5']})\n"
      when 3
        content = content + ", #{appointment['customField4'] if appointment['customField4']} (#{appointment['customField5'] if appointment['customField5']}), #{appointment['customField6'] if appointment['customField6']} (#{appointment['customField7'] if appointment['customField7']}) \n"
      else

      end

      content = content + "Appointment: #{app_obj.time.strftime("%b %d,%l:%M%p")}\n"

      content = content + "Comments: #{appointment['customField9'] ? appointment['customField9'] : "No comments."}"

      content
    end
end
