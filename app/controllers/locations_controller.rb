class LocationsController < ApplicationController
  before_filter :authenticate_user!, :except => ["show"]
  before_filter :authorize_admin, :except => ["show"]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @location_students_restarting = @location.students.restarting
    @total_location_students_count = @location.students.active.count
    @location_future_adds = @location.students.future_adds

    @offerings = @location.offerings
    @recruit_count = 0
    @tech_count = 0
    @operative_count = 0
    @analyst_count = 0
    @agent_count = 0
    @specialops_count = 0
    @prealgebra_count = 0
    @algebra_count = 0
    @geometry_count = 0
    @e_math_team_count = 0
    @m_math_team_count = 0
    @chess_club_count = 0
    @lego_robotics_count = 0

    @offerings.each do |offering|
      if offering.course_id == 1
        @recruit_count += offering.students.active.count
      elsif offering.course_id == 2
        @tech_count += offering.students.active.count
      elsif offering.course_id == 3
        @operative_count += offering.students.active.count
      elsif offering.course_id == 4
        @analyst_count += offering.students.active.count
      elsif offering.course_id == 5
        @agent_count += offering.students.active.count
      elsif offering.course_id == 6
        @specialops_count += offering.students.active.count
      elsif offering.course_id == 7
        @prealgebra_count += offering.students.active.count
      elsif offering.course_id == 8
        @algebra_count += offering.students.active.count
      elsif offering.course_id == 9
        @geometry_count += offering.students.active.count
      elsif offering.course_id == 10
        @chess_club_count += offering.students.active.count
      elsif offering.course_id == 11
        @lego_robotics_count += offering.students.active.count
      elsif offering.course_id == 13
        @e_math_team_count += offering.students.active.count
      elsif offering.course_id == 17
        @m_math_team_count += offering.students.active.count
      else
      end
    end

    @enrollment_total = @recruit_count + @tech_count + @operative_count + @analyst_count + @agent_count +
                        @specialops_count + @prealgebra_count + @algebra_count + @geometry_count +
                        @e_math_team_count + @m_math_team_count + @chess_club_count + @lego_robotics_count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def import
    Location.import(params[:file])
    redirect_to locations_path, notice: "Locations imported."
  end
end
