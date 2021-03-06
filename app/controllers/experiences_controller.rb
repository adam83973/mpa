class ExperiencesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :authorize_employee, except: [:show]
  before_action :set_experience, only: [:show, :edit, :update, :destroy]

  skip_before_action :authorize_active, only: :show
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
    @experience.build_badge if @experience.badge.nil?
  end

  # POST /experiences
  # POST /experiences.json
  def create
    @experience = Experience.new(experience_params)

    respond_to do |format|
      if @experience.save
        format.html { redirect_to experience_path(@experience), notice: 'Experience was successfully created.' }
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
    respond_to do |format|
      if @experience.update_attributes(experience_params)
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

  private

  def experience_params
    params.require(:experience).permit(:category, :content, :name, :points,
                                       :image, :remove_image, {resource_ids:[]},
                                       :remote_image_url, :occupation_id, :active,:subdomain,
                                       {badge_attributes: [:write_up_required,
                                       :multiple, :requires_approval, :image,
                                       :badge_category_id, :submission_type,
                                       :attendance, :course_id,:remove_image,
                                       :requirements, :name, :experience_id, :subdomain]})
  end

  def set_experience
    @experience = Experience.find(params[:id])
  end
end
