class StudentsController < ApplicationController
  before_action :verify_current_company
  before_action :authenticate_user!
  before_action :authorize_employee, except: [ :show, :update, :badges ]

  def change_current_occupation
    @student = Student.find(params[:student_id])
    if @student.update_attribute :current_occupation_id, params[:occupation_id]
      redirect_to student_path(@student), flash: { success: 'Student occupation changed!'}
    else
      redirect_to student_path(@student), alert: 'We were unable to change your occupation.'
    end
  end

  def badges
    @student = Student.find(params[:id])
    @earned_badges_with_count = @student.earned_badges_with_count.sort_by{|k,v| v}.reverse
  end

  # GET /students
  # GET /students.json
  def index
    if current_user.employee?
      @students = Student.includes(:user)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @students }
        format.csv { send_data @students.to_csv }
      end
    else
      redirect_to root_path
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    @registrations = @student.registrations.order(:status).includes(:offering, :course, :location)
    @note = Note.new
    @transaction = Transaction.new
    @homework_assessment_exp = Experience.where("category = ? OR category = ?", 'Homework', 'Assessment')
    @occupations = Occupation.order(:id).all
    @student_opportunities = @student.opportunities.includes(:offering)
    @active_offerings = Offering.includes(:course, :location).where(active: true).order("course_id ASC")
    @earned_badges_with_count = @student.earned_badges_with_count.sort_by{|k,v| v}.reverse.first(7)

    if current_user.employee? || current_user.id == @student.user_id
      # Sets instance variable for student offering, used to print binder
      # for elementary classes.
      if @student.offerings
        @agent_offerings = @student.offerings.where("course_id < ?", 7)
        @agent_offering = @agent_offerings.first
      end
      # Sets instance variable for student offering, used to print binder for
      # middle school and brain builder classes.
      if @student.offerings
        @offerings = @student.offerings.where("course_id > ?", 6)
        @second_offering = @offerings.first
      end

      # @student.offerings.each do |offering|
      #   if [11].include?(offering.course_id)
      #     @robotics_student = true
      #   end
      # end

      #Tags negative comments to allow styling in student show
      @student_comments = ExperiencePoint.where("student_id  = ? AND updated_at > ?", @student.id, 21.days.ago ).order('created_at desc').limit('20').to_a
      help_session_records = @student.help_session_records
      help_session_records.each{|help_session_record| @student_comments << help_session_record}
      @student_comments.sort!{|a, b| b['created_at'] <=> a['created_at']}

      @student_xps = ExperiencePoint.where("student_id = ?", @student.id)
      @robotics_achievements = Experience.where("category = ?", "Robotics").order("id asc")

      #get grades for student
      @student_xps = ExperiencePoint.where("student_id = ?", @student.id)

      @grades = Grade.where("student_id = ?", @student.id)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @student }
      end
    else
      redirect_to root_path
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new
    @parents = User.where("role = ?", "Parent").order('last_name')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    set_student
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_path(@student), notice: 'Student was successfully created.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_opportunity
    @opportunity = Opportunity.find(params[:student][:opportunity_id])
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        @opportunity.update_attribute :student_id, @student.id
        format.html { redirect_to student_path(@student), notice: 'Student was successfully created.' }
        format.js
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    set_student

    respond_to do |format|
      if @student.update_attributes(student_params)
        format.html { redirect_to student_path(@student), notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  def update_credits
    @student = Student.find(params[:credits][:id])
    @user_id = params[:credits][:user_id]
    @credits = params[:credits][:credits]
    @item = params[:credits][:item]

    if @student.credits >= @credits.to_i
      @student.redeem_credit(@credits)
      Note.create(
                  user_id: @user_id.to_i,
                  notable_id: @student.id,
                  notable_type: @student.class.name,
                  content: "Redeemed #{@credits} credits for #{@item}.")

      respond_to do |format|
        format.html { redirect_to student_path(@student), notice: "#{@student.full_name} spent #{@credits} credits." }
        format.json { render json: @credits }
        format.js
      end
    end
  end

  def attended_first_class
    @student = Student.find(params[:id])

    if @student.update_attribute :attended_first_class, true
      redirect_to root_path, notice: "It has been recorded that the student has attended their first class."
    end
  end

  def import
    Student.import(params[:file])
    redirect_to students_path, notice: "Students imported."
  end

  def last_attendance
    student = Student.find(params[:student_id])
    last_attendance = student.last_attendance

    if last_attendance
      last_attendance_date = view_context.last_attendance_date last_attendance
    else
      last_attendance_date = "<span>No Attendance</span>"
    end

    respond_to do |format|
      format.json { render json: last_attendance_date }
    end
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:birth_date, :first_name, :last_name, :offering_ids, :user_id,
                     :start_date, :xp_total, :credits, :rank, :active, :status,
                     :restart_date, :return_date, :end_date, :hold_status,
                     :start_hold_date, :opportunity_id, :avatar_id, :avatar_background_color, :has_learning_plan, :current_occupation_id)
    end
end
