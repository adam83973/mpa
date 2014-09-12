class EnrollmentChangeRequestsController < ApplicationController
  # GET /enrollment_change_requests
  # GET /enrollment_change_requests.json
  def index
    @enrollment_change_requests = EnrollmentChangeRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @enrollment_change_requests }
    end
  end

  # GET /enrollment_change_requests/1
  # GET /enrollment_change_requests/1.json
  def show
    @enrollment_change_request = EnrollmentChangeRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @enrollment_change_request }
    end
  end

  # GET /enrollment_change_requests/new
  # GET /enrollment_change_requests/new.json
  def new
    @enrollment_change_request = EnrollmentChangeRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @enrollment_change_request }
    end
  end

  # GET /enrollment_change_requests/1/edit
  def edit
    @enrollment_change_request = EnrollmentChangeRequest.find(params[:id])
  end

  # POST /enrollment_change_requests
  # POST /enrollment_change_requests.json
  def create
    @enrollment_change_request = EnrollmentChangeRequest.new(params[:enrollment_change_request])

    respond_to do |format|
      if @enrollment_change_request.save
        format.html { redirect_to @enrollment_change_request, notice: 'Enrollment change request was successfully created.' }
        format.json { render json: @enrollment_change_request, status: :created, location: @enrollment_change_request }
      else
        format.html { render action: "new" }
        format.json { render json: @enrollment_change_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /enrollment_change_requests/1
  # PUT /enrollment_change_requests/1.json
  def update
    @enrollment_change_request = EnrollmentChangeRequest.find(params[:id])

    respond_to do |format|
      if @enrollment_change_request.update_attributes(params[:enrollment_change_request])
        format.html { redirect_to @enrollment_change_request, notice: 'Enrollment change request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @enrollment_change_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollment_change_requests/1
  # DELETE /enrollment_change_requests/1.json
  def destroy
    @enrollment_change_request = EnrollmentChangeRequest.find(params[:id])
    @enrollment_change_request.destroy

    respond_to do |format|
      format.html { redirect_to enrollment_change_requests_url }
      format.json { head :no_content }
    end
  end
end
