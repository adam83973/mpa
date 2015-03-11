class ExperiencesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :authorize_employee, except: [:show]

  skip_before_filter :authorize_active, only: :show
  # GET /experiences
  # GET /experiences.json
  def index
    @experiences = Experience.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @experiences }
      format.csv { send_data @experiences.to_csv }
    end
  end

  # GET /experiences/1
  # GET /experiences/1.json
  def show
    @experience = Experience.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experience }
    end
  end

  # GET /experiences/new
  # GET /experiences/new.json
  def new
    @action = "new"
    @experience = Experience.new
    @experience.build_badge

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @experience }
    end
  end

  # GET /experiences/1/edit
  def edit
    @action = "edit"
    @experience = Experience.find(params[:id])
    @experience.build_badge if @experience.badge.nil?
  end

  # POST /experiences
  # POST /experiences.json
  def create
    @experience = Experience.new(params[:experience])

    respond_to do |format|
      if @experience.save
        format.html { redirect_to @experience, notice: 'Experience was successfully created.' }
        format.json { render json: @experience, status: :created, location: @experience }
      else
        format.html { render action: "new" }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiences/1
  # PUT /experiences/1.json
  def update
    @experience = Experience.find(params[:id])

    respond_to do |format|
      if @experience.update_attributes(params[:experience])
        format.html { redirect_to @experience, notice: 'Experience was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiences/1
  # DELETE /experiences/1.json
  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy

    respond_to do |format|
      format.html { redirect_to experiences_url }
      format.json { head :no_content }
    end
  end

  def import
    Experience.import(params[:file])
    redirect_to experiences_path, notice: "Experiences imported."
  end
end
