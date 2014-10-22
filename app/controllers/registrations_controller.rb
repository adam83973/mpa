class RegistrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registrations }
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    @registration = Registration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.json
  def new
    @registration = Registration.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find(params[:id])
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(params[:registration])

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
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
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def switch
    @registration = Registration.find(params[:switch][:registration_id].to_i)
    @student = Student.find(params[:switch][:student_id])
    @offering = Offering.find(params[:switch][:offering_id])

    respond_to do |format|
      if @new_registration = Registration.create!(start_date: params[:switch][:date],
                                                  offering_id: params[:switch][:offering_id],
                                                  student_id: params[:switch][:student_id],
                                                  attended_first_class: true,
                                                  switch: true,
                                                  status: 0)
        @registration.update_attributes( {end_date: params[:switch][:date], switch_id: @new_registration.id})
        format.html { redirect_to @student, notice: 'Change of classes has been submitted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request.' }
      end
    end
  end

  def drop
    @registration = Registration.find(params[:drop][:registration_id].to_i)
    @student = Student.find(@registration.student_id)

    respond_to do |format|
      if @registration.update_attribute :end_date, params[:drop][:end_date]
        format.html { redirect_to infusion_pages_subscription_path(ContactId: @student.user.infusion_id), notice: "End date has been added. Please update this user's subscriptions." }
        format.json { head :no_content }
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def cancel_drop
    @registration = Registration.find(params[:registration_id].to_i)
    @student = Student.find(@registration.student_id)

    respond_to do |format|
      if @registration.update_attribute :end_date, nil
        if @registration.switch_id
          # delete registration if one was created through switching classes
          Registration.find(@registration.switch_id).destroy
          @registration.update_attribute :switch_id, nil # remove switch ID from current reg
          format.html { redirect_to @student, notice: 'End date has been removed. This registration was being switched to another class. The registration associated with this switch has been deleted.' }
          format.json { head :no_content }
        else
          format.html { redirect_to infusion_pages_subscription_path(ContactId: @student.user.infusion_id), notice: 'End date has been removed. If a subscription has been ended please start a new one.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def hold
    @registration = Registration.find(params[:hold][:registration_id].to_i)
    @restart_registration = Registration.new
    @student = Student.find(@registration.student_id)

    # Set hold date on current registration. This date will be used as the date to set registration to inactive.
    @registration.update_attribute :hold_date, params[:hold][:hold_date]

    respond_to do |format|
    # Create new registration with restart date. Restart date is date when registration will become active. Status is set to hold and hold_id is record of associated registration (i.e. the registration that was cancelled when the hold began)
      if @restart_registration = Registration.create!(restart_date: params[:hold][:restart_date],
                                                      offering_id: @registration.offering_id,
                                                      student_id: @student.id,
                                                      status: 2,
                                                      attended_first_class: true,
                                                      hold_id: @registration.id)
        format.html { redirect_to infusion_pages_subscription_path(ContactId: @student.user.infusion_id), notice: 'Hold request has been processed. Please adjust the subscription for this student.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def cancel_hold
    @ending_registration = Registration.find(params[:registration_id].to_i)
    @restarting_registration = @ending_registration.holding
    @student = @ending_registration.student

    respond_to do |format|
      if @ending_registration.update_attribute :hold_date, nil
        if @restarting_registration.destroy
          # delete registration if one was created through switching classes
          format.html { redirect_to infusion_pages_subscription_path(ContactId: @student.user.infusion_id), notice: 'Hold has been cancelled. Please adjust subscriptions.' }
          format.json { head :no_content }
        end
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request. Please resubmit your request. If the problem persists contact Travis.' }
      end
    end
  end

  def attended_first_class
    @registration = Registration.find(params[:id])
    @student = @registration.student

    if @registration.update_attribute :attended_first_class, true
      redirect_to root_path, notice: "#{@student.full_name} has attended their first class."
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration = Registration.find(params[:id])
    @student = Student.find(@registration.student_id)
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to @student }
      format.json { head :no_content }
    end
  end
end
