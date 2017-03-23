class CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: [:show]
  before_filter :authorize_admin, except: [:show, :index]
  before_action :set_course, only: [:show, :edit, :update, :destroy]



  # GET /courses
  # GET /courses.json

  def index
    @courses = Course.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
      format.csv { send_data @courses.to_csv }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update_attributes(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  def import
    Course.import(params[:file])
    redirect_to courses_path, notice: "Course imported."
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name, :description, :grade, :occupation_id, :capacity)
    end
end
