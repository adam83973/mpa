class ExperiencePointsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: :show

  # GET /experience_points
  # GET /experience_points.json
  def index
    @experience_points = ExperiencePoint.includes(:student, :user, :experience)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @experience_points }
    end
  end

  # GET /experience_points/1
  # GET /experience_points/1.json
  def show
    @experience_point = ExperiencePoint.find(params[:id])

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
    @experience_point = ExperiencePoint.new(params[:experience_point])
    if params[:experience_point][:student_id].empty?
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @experience_point.errors, status: :unprocessable_entity }
      end
      false
    else
      @student = Student.find(params[:experience_point][:student_id])
      @student_json = @student.to_json
      @credits = @student.calculate_credit(@experience_point)
      @student_level = @student.calculate_rank(@experience_point)
      @response = @student.to_json

      # find ids of experiences that are related to attendance
      @attendance_exps = Experience.where("name LIKE ?", "%Attendance%")
      @exp = []
      @attendance_exps.each do |exp|
        @exp << exp.id
      end

      #add credits and special redirect when attendance is taken
      #add .js response for ajax
      if @exp.include?(params[:experience_point][:experience_id].to_i)

        #add student attendance from teacher home page
        if class_session.in_session?
         class_session.add_student(@student)
        end

        respond_to do |format|
          if @experience_point.save
            # add credits to students account based on earned xp
            if @credits > 0
              @student.add_credit(@credits)
            end

            # update level for occupation based on experience point's occupation relation
            @experience_point.occupation ? @student.update_level(@experience_point.occupation.title) : ""

            format.html { redirect_to student_path(@student), notice: "Attendance added for #{@student.first_name}." }
            format.js
            format.json { render json: @experience_point, status: :created, location: @experience_point }

          else
            format.html { render root_path }
            format.json { render json: @experience_point.errors, status: :unprocessable_entity }
          end
        end
      # elsif params[:experience_point][:experience_id] == "1"

      elsif ["1", "4", "5"].include?(params[:experience_point][:experience_id])

        respond_to do |format|
          if @experience_point.save
            if @credits > 0
                  @student.add_credit(@credits)
            end

            # update level for occupation based on experience point's occupation relation
            @experience_point.occupation ? @student.update_level(@experience_point.occupation.title) : ""

            format.html { redirect_to new_experience_point_path(:homework => '1'), notice: "Grade added for #{@student.first_name} : #{@experience_point.experience.name}." }
            format.json { render json: @experience_point, status: :created, location: @experience_point }
          else
            format.html { render action: "new" }
            format.json { render json: @experience_point.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          if @experience_point.save
            if @credits > 0
              @student.add_credit(@credits)
            end

            # update level for occupation based on experience point's occupation relation
            @experience_point.occupation ? @student.update_level(@experience_point.occupation.title) : ""

            #check to see if badge is associated with experience point's experience
            @badge_earned = @experience_point.add_badge?(@student)

            format.html { redirect_to student_path(@student), notice: "Experience point was successfully created. #{'You earned a badge!' if @badge_earned }" }
            format.json { render json: @experience_point, status: :created, location: @experience_point }
          else
            format.html { render action: "new" }
            format.json { render json: @experience_point.errors, status: :unprocessable_entity }
          end
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
      if @experience_point.update_attributes(params[:experience_point])

        # update level for occupation based on experience point's occupation relation
        @experience_point.occupation ? @student.update_level(@experience_point.occupation.title) : ""

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

    # update level for occupation based on experience point's occupation relation
    @experience_point.occupation ? @student.update_level(@experience_point.occupation.title) : ""

    respond_to do |format|
      format.html { redirect_to student_path(@student), notice: 'Experience point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
