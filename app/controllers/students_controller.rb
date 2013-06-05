class StudentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
      format.csv { send_data @students.to_csv }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    @student_comment_feed = ExperiencePoint.where("student_id  = ? AND updated_at > ?", @student.id, 21.days.ago ).order('created_at desc').limit('20')
    @robotics_achievements = Experience.where("category = ?", "Robotics")
#loop is broken and sets :completed to false after it's been set to true, only works when the last id is the one that matches.
    @student.experience_points.each do |xp|
      @robotics_achievements.each do |achievement|
      achievement[:completed] = []
        if achievement.id == xp.experience_id
          achievement[:completed] << true
          break
        else
          achievement[:completed] << false
        end
      end
    end

      if signed_in?
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @student }
      end
    else
      redirect_to new_user_session_path, notice: "Please log in to access additional information."
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
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

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

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
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

  def import
    Student.import(params[:file])
    redirect_to students_path, notice: "Students imported."
  end
end
