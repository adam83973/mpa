class StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: [ :show, :update, :badges ]

  def badges
    @student = Student.find(params[:id])
    @earned_badges_with_count = @student.earned_badges_with_count.sort_by{|k,v| v}.reverse
  end

  # GET /students
  # GET /students.json
  def index
    if current_user.employee?
      @students = Student.includes(:user, :offerings).order(:id).limit(10)
      @active_students = Student.includes(:user, :offerings).active
      @inactive_students = Student.includes(:user, :offerings).where("status = ? OR status = ?", "Inactive", "Hold")

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
    set_student
    @registrations = @student.registrations.order(:status).includes(:offering, :course, :location)
    @note = Note.new
    @homework_assessment_exp = Experience.where("category = ? OR category = ?", 'Homework', 'Assessment')
    @occupations = Occupation.order(:id).all
    @student_opportunities = @student.opportunities.includes(:offering)
    @active_offerings = Offering.where(active: true).order("course_id ASC")
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

      @student.offerings.each do |offering|
        if [11].include?(offering.course_id)
          @robotics_student = true
        end
      end

    #Tags negative comments to allow styling in student show
      @student_xp_comments = ExperiencePoint.includes(:user).where("student_id  = ? AND updated_at > ?", @student.id, 21.days.ago ).order('created_at desc').limit('20')
      @student_comment_feed = @student_xp_comments

        @student_xp_comments.each do |xp|
          if xp.points == 0 && xp.experience_id != 3
            xp[:negative] = 1
          else
            xp[:negative] = 0
          end
        end

      @student_xps = ExperiencePoint.where("student_id = ?", @student.id)
      @robotics_achievements = Experience.where("category = ?", "Robotics").order("id asc")

      #loop is broken and sets :completed to false after it's been set to true, only works when the last id is the one that matches.
      # if @student.experience_points.empty?
      #   @robotics_achievements.each do |achievement|
      #     achievement[:completed] = []
      #     achievement[:completed] << false
      #   end
      # else
      #   @robotics_achievements.each do |achievement|
      #     @student.experience_points.each do |xp|
      #       achievement[:completed] = []
      #
      #       if achievement.id == xp.experience_id
      #         achievement[:completed] << true
      #         break
      #       else
      #         achievement[:completed] << false
      #       end
      #     end
      #   end
      # end

      #get grades for student
      @student_xps = ExperiencePoint.where("student_id = ?", @student.id)

      @grades = Grade.where("student_id = ?", @student.id)

      if signed_in?
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @student }
        end
      else
        redirect_to new_user_session_path, notice: "Please log in to access additional information."
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
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_opportunity
    @opportunity = Opportunity.find(params[:student][:opportunity_id])
    @student = Student.new(params[:student].except!(:opportunity_id))

    respond_to do |format|
      if @student.save
        @opportunity.update_attribute :student_id, @student.id
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
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
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
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
        format.html { redirect_to @student, notice: "#{@student.full_name} spent #{@credits} credits." }
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
    @student = Student.find(params[:student_id])
    @last_attendance = @student.attendances.last

    if @last_attendance && @last_attendance.date
      # add switch to send span with styling based on how long ago attendance was
      last_attendance_date(@last_attendance)
    else
      @last_attendance_date = 'No Attendance'
    end

    respond_to do |format|
      format.json { render json: @last_attendance_date }
    end
  end

  private
    def last_attendance_date(attendance)
      date = attendance.date
      if date > Date.today - 14.days == true
        @last_attendance_date = "<span style='color:green;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
      elsif date <= Date.today - 14.days && date >= Date.today - 30.days == true
        @last_attendance_date = "<span style='color:orange;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
      elsif date < Date.today - 30.days == true
        @last_attendance_date = "<span style='color:red;'>#{@last_attendance.date.strftime("%D")}</span>".html_safe
      end
    end
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:birth_date, :first_name, :last_name, :offering_ids, :user_id,
                     :start_date, :xp_total, :credits, :rank, :active, :status,
                     :restart_date, :return_date, :end_date, :hold_status,
                     :start_hold_date, :opportunity_id, :avatar_id, :avatar_background_color, :has_learning_plan)
    end
end
