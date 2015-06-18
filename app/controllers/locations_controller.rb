class LocationsController < ApplicationController
  before_filter :authenticate_user!, :except => ["show", "list"]
  before_filter :authorize_admin, :except => ["show", "list"]

  # GET /locations
  # GET /locations.json
  def list
    @locations = Location.all
    @location_list = []
    @locations.each{|location| @location_list << [location.id, location.name]}

    respond_to do |format|
      format.json { render json: @location_list }
      format.html { render nothing: true}
    end
  end

  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @location_students_restarting = @location.registrations.restarting
    @total_location_students_count = @location.registrations.active.count
    @location_future_adds = @location.registrations.future_adds
    @location_hw_help_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 1.day, @location.id).where(reasonId: 37118).order(:time).delete_if{|appointment| appointment.status == "CANCELLED"}
    @location_assessment_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 1.day, @location.id).where(reasonId: 37117).order(:time).delete_if{|appointment| appointment.status == "CANCELLED"}

    @offerings = @location.offerings

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def import
    Location.import(params[:file])
    redirect_to locations_path, notice: "Locations imported."
  end
end
