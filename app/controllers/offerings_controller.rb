class OfferingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin

  # GET /offerings
  # GET /offerings.json
  def index
    if current_user.employee?
      @offerings = Offering.order(:id)
      @hold_return_students = Student.where("status = ? AND return_date != ?", "Hold", "nil")
      @hold_restart_students = Student.where("status = ? AND restart_date != ?", "Hold", "nil")

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @offerings }
        format.csv { send_data @offerings.to_csv }
      end
    else
      redirect_to root_path
    end
  end

  # GET /offerings/1
  # GET /offerings/1.json
  def show
    @offering = Offering.find(params[:id])

    @parent_emails = Array.new

    @offering.students.where("status=?", "Active").each do |student|
      @parent_emails << "#{student.user.email}" + "\n "
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offering }
      format.csv { send_data @parent_emails.join }
    end
  end

  # GET /offerings/new
  # GET /offerings/new.json
  def new
    if current_user.employee?
      @offering = Offering.new
      @teachers = User.where("role = ?", "Teacher").order('last_name')
      @all_teachers = User.where("role  = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor').order('last_name asc')

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @offering }
      end
    else
      redirect_to root_path
    end
  end

  # GET /offerings/1/edit
  def edit
    @offering = Offering.find(params[:id])
    @teachers = User.where("role = ?", "Teacher").order('last_name')
    @all_teachers = User.where("role  = ? OR role = ? OR role = ? OR role = ? OR role = ?", 'Teacher', 'Teaching Assistant', 'Robotics Instructor', 'Programming Instructor', 'Chess Instructor').order('last_name asc')
  end

  # POST /offerings
  # POST /offerings.json
  def create
    @offering = Offering.new(params[:offering])

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
      if @offering.update_attributes(params[:offering])
        format.html { redirect_to @offering, notice: 'Offering was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
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

end
