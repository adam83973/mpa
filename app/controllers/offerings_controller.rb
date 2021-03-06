class OfferingsController < ApplicationController
  before_action :verify_current_company
  before_action :authenticate_user!, except: :offerings_by_location
  before_action :authorize_employee, except: [:show, :offerings_by_location]
  before_action :authorize_admin, except: [:show, :index, :offerings_by_location, :attendance_report]

  # GET /offerings
  # GET /offerings.json
  def index
    if current_user.employee?
      @offerings = Offering.includes(:course, :location, :users).order(:id)
      if params[:students] == "all"
        @offerings = Offering.includes(:course, :location, :users).order(:id)
      else
        @offerings = @offerings.where(active: true)
      end
      @hold_return_students = Student.where("status = ? AND return_date != ?", "Hold", "nil")
      @hold_restart_students = Student.where("status = ? AND restart_date != ?", "Hold", "nil")

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @offerings }
        format.csv { send_data @offerings.to_csv }
      end
    else
      redirect_to root_path(subdomain: current_company.subdomain)
    end
  end

  # GET /offerings/1
  # GET /offerings/1.json
  def show
    @offering = Offering.find(params[:id])
    @upcomming_trials = @offering.opportunities.where("trial_date >= ?", Date.today)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offering }
      format.csv { send_data @offering.parent_email_to_csv }
    end
  end

  # GET /offerings/new
  # GET /offerings/new.json
  def new
    if current_user.employee?
      @offering = Offering.new
      @teachers = User.where("role = ? AND active = ?", "Teacher", true).order('last_name')
      @all_teachers = User.where("role = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor').where(active: true).order('last_name asc')

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @offering }
      end
    else
      root_path(subdomain: current_company.subdomain)
    end
  end

  # GET /offerings/1/edit
  def edit
    @offering = Offering.find(params[:id])
    @teachers = User.where("role = ? AND active = ?", "Teacher", true).order('last_name')
    @all_teachers = User.where("role  = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor').where(active: true).order('last_name asc')
  end

  # POST /offerings
  # POST /offerings.json
  def create
    @offering = Offering.new(offering_params)

    respond_to do |format|
      if @offering.save
        format.html { redirect_to @offering, notice: 'Offering was successfully created.' }
        format.json { render json: @offering, status: :created, location: @offering }
      else
        format.html { render action: "new" }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offerings/1
  # PUT /offerings/1.json
  def update
    @offering = Offering.find(params[:id])

    respond_to do |format|
      if @offering.update_attributes(offering_params)
        format.html { redirect_to @offering, notice: 'Offering was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  def offerings_by_location
    @offerings = Offering.joins(:course).where(location_id: params[:location_id].to_i).where(:courses => { specialization: true } ).where(active: true).order(:course_id)
    @offerings_list = []
    @offerings.each{|offering| @offerings_list << [offering.id, offering.offering_trial_name, offering.day]}

    respond_to do |format|
      format.html
      format.json { render json: @offerings_list }
    end
  end

  def attendance_report
    @offering = Offering.find(params[:id])
  end

  # DELETE /offerings/1
  # DELETE /offerings/1.json
  def destroy
    @offering = Offering.find(params[:id])
    @offering.destroy

    respond_to do |format|
      format.html { redirect_to offerings_url }
      format.json { head :no_content }
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |student|
        csv << offering.attributes.values_at(*column_names)
      end
    end
  end

  def import
    Offering.import(params[:file])
    redirect_to offerings_path, notice: "Offerings imported/updated."
  end

  def at_capacity
    offering = Offering.find(params[:id])
    response = offering.at_capacity?

    respond_to do |format|
      format.html
      format.json { render json: response }
    end
  end

  def course_id
    offering = Offering.find(params[:id])
    course_id = offering.course_id

    respond_to do |format|
      format.json { render json: course_id }
    end
  end

  private
    def offering_params
      params.require(:offering).permit(:comments, :course_id, :day, :graduation_year,
                                       :location_id, :time, {user_ids: []}, :active,
                                       :classroom, :hidden, :day_number)
    end
end
