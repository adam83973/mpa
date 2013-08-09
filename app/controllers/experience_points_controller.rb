class ExperiencePointsController < ApplicationController
  before_filter :authenticate_user!

  # GET /experience_points
  # GET /experience_points.json
  def index
    @experience_points = ExperiencePoint.all

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
    @student = Student.find(params[:experience_point][:student_id])
    @experience_point = ExperiencePoint.new(params[:experience_point])
    @credits = @student.calculate_credit(@experience_point)
    @student_level = @student.calculate_rank(@experience_point)

    if params[:experience_point][:experience_id] == "2"
      respond_to do |format|
        if @experience_point.save
          if @credits > 0
                @student.add_credit(@credits)
          end

          if @student.rank.nil?
            @student.update_rank
          end

          if @student_level > 0
            @student.update_rank
          end

          format.html { redirect_to new_experience_point_path(:attendance => '2'), notice: "Attendance added for #{@student.first_name}." }

          format.json { render json: @experience_point, status: :created, location: @experience_point }
        else
          format.html { render action: "new" }
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

          if @student.rank.nil?
            @student.update_rank
          end

          if @student_level > 0
            @student.update_rank
          end

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

          if @student.rank.nil?
            @student.update_rank
          end

          if @student_level > 0
            @student.update_rank
          end

          format.html { redirect_to student_path(@student), notice: "Experience point was successfully created." }
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
      if @experience_point.update_attributes(params[:experience_point])
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
    @calculate_rank = ((@student.xp_sum - @experience_point.points)/1000 - ((@student.xp_sum)/1000))
    @student.add_credit(@credits)

    if @calculate_rank < 0
      @student.decrease_rank
    end
    @experience_point.destroy

    respond_to do |format|
      format.html { redirect_to student_path(@student), notice: 'Experience point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
