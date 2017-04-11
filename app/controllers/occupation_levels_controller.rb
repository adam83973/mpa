class OccupationLevelsController < ApplicationController
  before_filter :authorize_admin

  # GET /occupation_levels
  # GET /occupation_levels.json
  def index
    @occupation_levels = OccupationLevel.includes(:occupation).order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @occupation_levels }
        format.csv { send_data @occupation_levels.to_csv }
    end
  end

  # GET /occupation_levels/1
  # GET /occupation_levels/1.json
  def show
    set_occupation_level

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
    set_occupation_level
  end

  # POST /occupation_levels
  # POST /occupation_levels.json
  def create
    @occupation_level = OccupationLevel.new(occupation_level_params)

    respond_to do |format|
      if @occupation_level.save
        format.html { redirect_to occupation_level_url(@occupation_level), notice: 'Occupation level was successfully created.' }
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
    set_occupation_level

    respond_to do |format|
      if @occupation_level.update_attributes(occupation_level_params)
        format.html { redirect_to occupation_level_url(@occupation_level), notice: 'Occupation level was successfully updated.' }
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
    set_occupation_level
    @occupation_level.destroy

    respond_to do |format|
      format.html { redirect_to occupation_levels_url }
      format.json { head :no_content }
    end
  end

  def import
    OccupationLevel.import(params[:file])
    redirect_to occupation_levels_path, notice: "Levels imported."
  end

  private
    def set_occupation_level
      @occupation_level = OccupationLevel.find(params[:id])
    end

    def occupation_level_params
      params.require(:occupation_level).permit(:level, :points, :rewards, :privileges, :notes, :occupation_id, :bonus_credits, :image, :product_id)
    end
end
