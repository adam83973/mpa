class LocationsController < ApplicationController
  before_action :authenticate_user!, :except => ["show", "list"]
  before_action :authorize_admin, :except => ["show", "list"]

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
    set_location
    set_location_stats
    set_location_appointments

    @offerings = @location.offerings

    set_chart_data

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
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to location_path(@location), notice: 'Location was successfully created.' }
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
    set_location

    respond_to do |format|
      if @location.update_attributes(location_params)
        format.html { redirect_to location_path(@location), notice: 'Location was successfully updated.' }
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
    set_location
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

  def registered_students
    set_location
    @active_registrations = @location.active_registrations

    respond_to do |format|
      format.html
      format.json { render json: @active_registrations }
    end
  end

  private
    def set_location_stats
      @active_offerings = @location.active_offerings
      @active_students = @location.registrations.active
      @future_adds = @location.registrations.future_adds
      @future_restarts = @location.registrations.future_restarts
      @students_restarting_next_20 = @location.registrations.restarting_next_20
      @added_last_30 = @location.registrations.added_last_30
      @dropped_last_30 = @location.registrations.dropped_last_30
    end

    def set_location_appointments
      @hw_help_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 1.day, @location.id).where(reasonId: current_company.check_appointments_homework_help_id).order(:time).to_a.delete_if{|appointment| appointment.status == "CANCELLED"}
      @assessment_appointments = Appointment.where("time >= ? AND time < ? AND location_id = ?", Date.today, Date.today + 7.days, @location.id).where(reasonId: current_company.check_appointments_assessment_id).order(:time).to_a.delete_if{|appointment| appointment.status == "CANCELLED"}
      @trials = Opportunity.where("trial_date >= ? AND trial_date < ? AND location_id = ?", Date.today, Date.today + 7.days, @location.id).order(:trial_date)
    end
    def location_params
      params.require(:location).permit(:address, :city, :franchise, :name, :state, :zip, :technical_information, :subdomain)
    end

    def set_location
      @location = Location.find(params[:id])
    end

    def set_chart_data
      @last_twelve_months = Date::MONTHNAMES[1..12].reverse.rotate(1-Time.now.month).reverse

      @location_reports = DailyLocationReport.where("created_at >= ? AND created_at <= ? AND location_id = ?",(Date.today - 12.month).beginning_of_month, (Date.today - 1.month).end_of_month, @location.id)

      average_monthly_enrollment

      @data = {
        labels: @last_twelve_months,
        datasets: [
          {
              label: "Average Enrollment by Month",
              fillColor: "rgba(220,220,220,0.2)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
              data: @monthly_averages
          }
        ]
      }

      @options = {
        width: '800',
        responsive: true,
        maintainAspectRatio: true
      }
    end

    def average_monthly_enrollment
      @monthly_averages = []
      reports_by_month = []
      @last_twelve_months.each_with_index do |month, i|
        monthly_reports = []
        @location_reports.each do |report|
          if report.created_at.strftime("%B") == month
            monthly_reports << report
          end
        end
        reports_by_month << monthly_reports
        @monthly_averages << reports_by_month[i].sum{|report| report.total_enrollment} / reports_by_month[i].size if reports_by_month[i].size > 0
      end
    end
end
