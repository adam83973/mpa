class OccupationLevelsController < ApplicationController
  # GET /occupation_levels
  # GET /occupation_levels.json
  def index
    @occupation_levels = OccupationLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @occupation_levels }
    end
  end

  # GET /occupation_levels/1
  # GET /occupation_levels/1.json
  def show
    @occupation_level = OccupationLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @occupation_level }
    end
  end

  # GET /occupation_levels/new
  # GET /occupation_levels/new.json
  def new
    @occupation_level = OccupationLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @occupation_level }
    end
  end

  # GET /occupation_levels/1/edit
  def edit
    @occupation_level = OccupationLevel.find(params[:id])
  end

  # POST /occupation_levels
  # POST /occupation_levels.json
  def create
    @occupation_level = OccupationLevel.new(params[:occupation_level])

    respond_to do |format|
      if @occupation_level.save
        format.html { redirect_to @occupation_level, notice: 'Occupation level was successfully created.' }
        format.json { render json: @occupation_level, status: :created, location: @occupation_level }
      else
        format.html { render action: "new" }
        format.json { render json: @occupation_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /occupation_levels/1
  # PUT /occupation_levels/1.json
  def update
    @occupation_level = OccupationLevel.find(params[:id])

    respond_to do |format|
      if @occupation_level.update_attributes(params[:occupation_level])
        format.html { redirect_to @occupation_level, notice: 'Occupation level was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @occupation_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occupation_levels/1
  # DELETE /occupation_levels/1.json
  def destroy
    @occupation_level = OccupationLevel.find(params[:id])
    @occupation_level.destroy

    respond_to do |format|
      format.html { redirect_to occupation_levels_url }
      format.json { head :no_content }
    end
  end
end
