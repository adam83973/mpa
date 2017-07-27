class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = Lesson.includes(:standard, :course)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lessons }
      format.csv { send_data @lessons.to_csv }
    end
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    @lesson = Lesson.includes(:standard, notes: [:notable, :user]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lesson }
    end
  end

  # GET /lessons/new
  # GET /lessons/new.json
  def new
    @lesson = Lesson.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lesson }
    end
  end

  # GET /lessons/1/edit
  def edit
    @lesson = Lesson.find(params[:id])
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: 'Lesson was successfully created.' }
        format.json { render json: @lesson, status: :created, location: @lesson }
      else
        format.html { render action: "new" }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lessons/1
  # PUT /lessons/1.json
  def update
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      if @lesson.update_attributes(lesson_params)
        format.html { redirect_to @lesson, notice: 'Lesson was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_error
    lesson = Lesson.find params[:lesson][:id]

    if lesson.update_attribute :contains_error, params[:lesson][:contains_error]
      response = params[:lesson][:contains_error]
      respond_to do |format|
        format.json { render json: response }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to lessons_url }
      format.json { head :no_content }
    end
  end

  def import
    Lesson.import(params[:file])
    redirect_to lessons_path, notice: "Lessons imported."
  end
  private

  def lesson_params
    params.require(:lesson).permit(:assessment, :assessment_key, :assignment, :contains_error, :assignment_key, :standard_id, :name, :week, :course_id, :starter, {resource_ids: []}, {problem_ids: []})
  end
end
