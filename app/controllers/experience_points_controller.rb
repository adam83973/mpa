class ExperiencePointsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: :show

  # GET /experience_points
  # GET /experience_points.json
  def index
    @experience_points = ExperiencePoint.includes(:student, :user, :experience).limit(500)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @experience_points }
    end
  end

  # GET /experience_points/1
  # GET /experience_points/1.json
  def show
    set_experience_point

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experience_point }
    end
  end

  # GET /experience_points/new
  # GET /experience_points/new.json
  def new
    @experience_point = ExperiencePoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @experience_point }
    end
  end

  def points_lookup
    @experience = Experience.find(params[:experience_id])
    @points = @experience.points

    respond_to do |format|
      format.json { render json: @points }
    end
  end

  # GET /experience_points/1/edit
  def edit
    @experience_point = ExperiencePoint.find(params[:id])
  end

  # POST /experience_points
  # POST /experience_points.json
  def create
    @experience_point = ExperiencePoint.new(experience_point_params)
    if !@experience_point.student_id
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @experience_point.errors, status: :unprocessable_entity }
      end
      false
    else
      @student = Student.find(@experience_point.student_id)

      respond_to do |format|
        if @experience_point.save
          format.html { redirect_to student_path(@student), notice: "Experience point added for #{@student.first_name} : #{@experience_point.experience.name}." }
          format.json { render json: @experience_point, status: :created, location: @experience_point }
        else
          format.html { render action: "new" }
          format.json { render json: @experience_point.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /experience_points/1
  # PUT /experience_points/1.json
  def update
    @student = Student.find(params[:experience_point][:student_id])
    @experience_point = ExperiencePoint.find(params[:id])

    respond_to do |format|
      if @experience_point.update_attributes(experience_point_params)

        format.html { redirect_to student_path(@student), notice: 'Experience point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @experience_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experience_points/1
  # DELETE /experience_points/1.json
  def destroy
    @experience_point = ExperiencePoint.find(params[:id])
    @student = Student.find(@experience_point.student_id)

    @experience_point.destroy

    respond_to do |format|
      format.html { redirect_to student_path(@student), notice: 'Experience point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def qc
    if params[:request]
      @user = User.find params[:request][:user_id] if params[:request][:user_id]
      number_of_days = params[:request][:days] ? params[:request][:days].to_i : 30
      @experience_points = ExperiencePoint.joins(:experience).where("experiences.name LIKE ?", "%Homework%").where("user_id = ? AND experience_points.created_at > ?", params[:request][:user_id], Date.today - number_of_days.days)
    else
      @experience_points = ExperiencePoint.joins(:experience).where("experiences.name LIKE ?", "%Homework%").last(30)
    end
  end

  private

    def update_level
      # update level for occupation based on experience point's occupation relation
      @student.update_level(@experience_point.occupation.title) if @experience_point.occupation
    end

    def set_experience_point
      @experience_point = ExperiencePoint.find(params[:id])
    end

    def experience_point_params
      params.require(:experience_point).permit(:experience_id, :points, :student_id, :user_id, :comment, :negative)
    end
end
