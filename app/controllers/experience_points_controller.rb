class ExperiencePointsController < ApplicationController
  # GET /experience_points
  # GET /experience_points.json
  def autocomplete_student_full_name
    autocomplete :student_id, :full_name
  end

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

  # GET /experience_points/1/edit
  def edit
    @experience_point = ExperiencePoint.find(params[:id])
  end

  # POST /experience_points
  # POST /experience_points.json
  def create
    @experience_point = ExperiencePoint.new(params[:experience_point])

    respond_to do |format|
      if @experience_point.save
        format.html { redirect_to @experience_point, notice: 'Experience point was successfully created.' }
        format.json { render json: @experience_point, status: :created, location: @experience_point }
      else
        format.html { render action: "new" }
        format.json { render json: @experience_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experience_points/1
  # PUT /experience_points/1.json
  def update
    @experience_point = ExperiencePoint.find(params[:id])

    respond_to do |format|
      if @experience_point.update_attributes(params[:experience_point])
        format.html { redirect_to @experience_point, notice: 'Experience point was successfully updated.' }
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
    @experience_point.destroy

    respond_to do |format|
      format.html { redirect_to experience_points_url }
      format.json { head :no_content }
    end
  end
end
