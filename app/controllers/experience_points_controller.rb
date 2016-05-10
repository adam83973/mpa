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
    puts 'xp loaded'
    if !@experience_point.student_id
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @experience_point.errors, status: :unprocessable_entity }
      end
      false
    else
      puts 'adding credit'
      @student = Student.find(@experience_point.student_id)
      @student_json = @student.to_json
      @credits = @student.calculate_credit(@experience_point)
      @student_level = @student.calculate_rank(@experience_point)
      @response = @student.to_json

      # find ids of experiences that are related to attendance
      @attendance_experience_points = Experience.where("name LIKE ?", "%Attendance%")
      @attendance_xp = []
      @attendance_experience_points.each do |exp|
        @attendance_xp << exp.id
      end

      #add credits and special redirect when attendance is taken
      #add .js response for ajax
      if @attendance_xp.include?(@experience_point.experience_id.to_i)
        puts 'a'
        take_attendance
      #add homework score and special redirect
      elsif ["1", "4", "5"].include?(@experience_point.experience_id)
        puts 'b'
        add_homework_score
      else
        puts 'c'
        add_experience_point
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
    @credits = ((@student.xp_sum - @experience_point.points)/100 - ((@student.xp_sum)/100))
    @student.add_credit(@credits)

    @experience_point.destroy

    update_level

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
    def take_attendance
      #add student attendance from teacher home page
      if class_session.in_session?
       class_session.add_student(@student)
      end

      respond_to do |format|
        if @experience_point.save!
          # add credits to students account based on earned xp
          if @credits > 0
            @student.add_credit(@credits)
          end

          update_level

          format.html { redirect_to student_path(@student), notice: "Attendance added for #{@student.first_name}." }
          format.js
          format.json { render json: @experience_point, status: :created, location: @experience_point }
        else
          format.html { redirect_to root_path }
          format.json { render json: @experience_point.errors, status: :unprocessable_entity }
        end
      end
      # elsif params[:experience_point][:experience_id] == "1"
    end

    def add_homework_score
      respond_to do |format|
        if @experience_point.save
          if @credits > 0
                @student.add_credit(@credits)
          end

          update_level

          format.html { redirect_to new_experience_point_path(:homework => '1'), notice: "Grade added for #{@student.first_name} : #{@experience_point.experience.name}." }
          format.json { render json: @experience_point, status: :created, location: @experience_point }
        else
          format.html { render action: "new" }
          format.json { render json: @experience_point.errors, status: :unprocessable_entity }
        end
      end
    end

    def add_experience_point
      respond_to do |format|
        if @experience_point.save
          if @credits > 0
            @student.add_credit(@credits)
          end

          update_level

          format.html { redirect_to student_path(@student), notice: "Experience point was successfully created. #{'You earned a badge!' if @badge_earned }" }
          format.json { render json: @experience_point, status: :created, location: @experience_point }
        else
          format.html { render action: "new" }
          format.json { render json: @experience_point.errors, status: :unprocessable_entity }
        end
      end
    end

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
