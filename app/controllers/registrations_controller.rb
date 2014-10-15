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
                                                  location_id: @offering.location_id,
                                                  status: 0)
        @registration.update_attribute :end_date, params[:switch][:date]
        format.html { redirect_to @student, notice: 'Classes have been switched.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @student, notice: 'There has been a problem processing your request.' }
      end
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
