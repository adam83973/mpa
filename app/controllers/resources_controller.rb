class ResourcesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.order(:id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
      format.csv { send_data @resources.to_csv }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.create(params[:resource])

    # @resource = Resource.new(params[:resource])

    # respond_to do |format|
    #   if @resource.save
    #     format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
    #     format.json { render json: @resource, status: :created, location: @resource }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @resource.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @lessons = Lesson.where('assignment = ? OR assignment_key = ?', @resource.id, @resource.id)

    @lessons.each do |lesson|
      if @resource.is_lesson?
        lesson.update_attributes assignment: nil
      elsif @resource.is_lesson_key?
        lesson.update_attributes assignment_key: nil
      else
      end
    end
    @resource.destroy


    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end

  def import
    Resource.import(params[:file])
    redirect_to resources_path, notice: "Resources imported."
  end
end
