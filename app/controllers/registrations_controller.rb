class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registrations }
      format.csv { send_data @registrations.to_csv }
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    set_registration
    @student = @registration.student

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.json
  def new
    @registration = Registration.new
    @active_offerings = Offering.order(:course_id, :location_id, :day_number).includes(:course, :location).where("active = ?", true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
    set_registration
    @active_offerings = Offering.order(:course_id, :location_id, :day_number).includes(:course, :location).where("active = ?", true)
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    @student = @registration.student

    respond_to do |format|
      if @registration.save
        activate_registration
        format.html { redirect_to student_path(@student), notice: 'Registration was successfully created.' }
        format.json { render json: @registration, status: :created, location: @registration }
      else
        format.html { render action: "new" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /registrations/1
  # PUT /registrations/1.json
  def update
    set_registration

    respond_to do |format|
      if @registration.update_attributes(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def switch
    @registration = Registration.find(params[:registration][:id])
    @student = @registration.student
    # Class that student is switching to.
    @new_offering = Offering.find(params[:registration][:offering_id])

    respond_to do |format|
      if @new_registration = Registration.create!(start_date:             params[:registration][:switch_date],
                                                  offering_id:            @new_offering.id,
                                                  student_id:             @student.id,
                                                  attended_first_class:   true,
                                                  switch:                 true,
                                                  status:                 0)

        @registration.update_attributes(end_date:       params[:registration][:switch_date],
                                        switch_id:      @new_registration.id)

        if @new_registration.start_date <= Date.today
          @new_registration.update_attribute :status, 1
        end

        format.html { redirect_to student_path(@student), notice: 'Change of classes has been submitted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to student_path(@student), notice: 'There has been a problem processing your request. Please resubmit.' }
      end
    end
  end

  def drop
    @registration = Registration.find(params[:registration][:id])
    @student = @registration.student
    @parent = @student.user

    respond_to do |format|
      if @registration.update_attribute :end_date, params[:registration][:end_date]
        # Add note with action for the following day to ensure subscription has been cancelled.
        note = @parent.notes.build({
          content: "#{@student.first_name} has dropped a class. Please double check their subscriptions.",
          user_id: @parent.class.system_admin_id,
          location_id: @registration.location.id,
          action_date: Date.tomorrow})
        note.save

        format.html { redirect_to infusion_pages_subscription_path(userId: @student.user.id), notice: "End date has been added. Please update this user's subscriptions." }
        format.json { head :no_content }
      else
        format.html { redirect_to student_path(@student), notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def cancel_drop
    @registration = Registration.find(params[:registration][:id])
    @student = Student.find(@registration.student_id)

    respond_to do |format|
      if @registration.update_attribute :end_date, nil
        if @registration.switch_id
          # delete registration if one was created through switching classes
          Registration.find(@registration.switch_id).destroy
          @registration.update_attribute :switch_id, nil # remove switch ID from current reg
          format.html { redirect_to student_path(@student), notice: 'End date has been removed. This registration was being switched to another class. The registration associated with this switch has been deleted.' }
          format.json { head :no_content }
        else
          format.html { redirect_to infusion_pages_subscription_path(userId: @student.user.id), notice: 'End date has been removed. If a subscription has been ended please start a new one.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to student_path(@student), notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def hold
    @registration = Registration.find(params[:registration][:id])
    @restart_registration = Registration.new
    @student = @registration.student
    @parent = @student.user

    # Set hold date on current registration. This date will be used as the date to set registration to inactive.
    @registration.update_attribute :hold_date, params[:registration][:hold_date]

    respond_to do |format|
    # Create new registration with restart date. Restart date is date when registration will become active. Status is set to hold and hold_id is record of associated registration (i.e. the registration that was cancelled when the hold began)
      if @restart_registration = Registration.create!(restart_date: params[:registration][:restart_date],
                                                      offering_id: @registration.offering_id,
                                                      student_id: @student.id,
                                                      status: 2,
                                                      attended_first_class: true,
                                                      hold_id: @registration.id)

        note = @parent.notes.build({content: "#{@student.first_name} has entered a hold. Please double check their subscriptions.",
                                    user_id: @parent.class.system_admin_id,
                                    location_id: @registration.location.id,
                                    action_date: Date.tomorrow})
        note.save
        if current_company.infusionsoft_integration?
          format.html { redirect_to infusion_pages_subscription_path(userId: @student.user.id), notice: 'Hold request has been processed. Please adjust the subscription for this student.' }
          format.json { head :no_content }
        else
          format.html { redirect_to student_path(@student), notice: 'Hold request has been processed.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to student_path(@student), notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def cancel_hold
    @registration = Registration.find(params[:registration][:id])
    @restarting_registration = @registration.holding
    @student = @registration.student

    respond_to do |format|
      if @registration.update_attribute :hold_date, nil
        if @restarting_registration.destroy
          # delete registration if one was created through switching classes
          if current_company.infusionsoft_integration?
            format.html { redirect_to infusion_pages_subscription_path(userId: @student.user.id), notice: 'Hold has been cancelled. Please adjust subscriptions.' }
            format.json { head :no_content }
          else
            format.html { redirect_to student_path(@student), notice: 'Hold has been cancelled.' }
            format.json { head :no_content }
          end
        end
      else
        format.html { redirect_to student_path(@student), notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def attended_first_class
    set_registration
    @student = @registration.student

    if @registration.update_attributes attended_first_class: true, status: 1
      redirect_to root_url, notice: "#{@student.full_name} has attended their first class."
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    set_registration
    @student = Student.find(@registration.student_id)
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to student_path(@student) }
      format.json { head :no_content }
    end
  end

  def activate
    set_registration
    @student = @registration.student

    if @registration.start_date
      if @registration.start_date <= Date.today
        @registration.update_attribute :status, 1

        respond_to do |format|
          format.html { redirect_to student_path(@student), notice: 'Registration Activated.' }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to student_path(@student), notice: 'You must enter a start date for this registration.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def activate_registration
      if @registration.status == 0 && @registration.start_date <= Date.today
        @registration.update_attribute :status, 1
      end
    end

    def registration_params
      params.require(:registration).permit(:admin_id, :attended_first_class, :attended_trial, :end_date, :hold_date, :offering_id, :start_date, :status, :student_id, :trial_date, :hold_id, :switch_id, :switch, :restart_date, :drop_reason, :payment_information_later)
    end

    def set_registration
      @registration = Registration.find(params[:id])
    end
end
