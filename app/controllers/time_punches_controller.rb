class TimePunchesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  # GET /time_punches
  # GET /time_punches.json
  def index
    @time_punches = TimePunch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_punches }
    end
  end

  # GET /time_punches/1
  # GET /time_punches/1.json
  def show
    @time_punch = TimePunch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_punch }
    end
  end

  # GET /time_punches/new
  # GET /time_punches/new.json
  def new
    @time_punch = TimePunch.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_punch }
    end
  end

  # GET /time_punches/1/edit
  def edit
    @time_punch = TimePunch.find(params[:id])
  end

  # POST /time_punches
  # POST /time_punches.json
  def create
    @time_punch = TimePunch.new(params[:time_punch])

    respond_to do |format|
      if @time_punch.save
        format.html { redirect_to @time_punch, notice: 'Time punch was successfully created.' }
        format.json { render json: @time_punch, status: :created, location: @time_punch }
      else
        format.html { render action: "new" }
        format.json { render json: @time_punch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /time_punches/1
  # PUT /time_punches/1.json
  def update
    @time_punch = TimePunch.find(params[:id])

    respond_to do |format|
      if @time_punch.update_attributes(params[:time_punch])
        format.html { redirect_to @time_punch, notice: 'Time punch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_punch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_punches/1
  # DELETE /time_punches/1.json
  def destroy
    @time_punch = TimePunch.find(params[:id])
    @time_punch.destroy

    respond_to do |format|
      format.html { redirect_to time_punches_url }
      format.json { head :no_content }
    end
  end
end
