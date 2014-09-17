class EnrollmentChangeRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee, except: [:new, :create]
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
    @student = Student.find(params[:student_id])

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
        # Send ecr_received email and update ecr submission_confirmation_email attribute to true if submission_confirmation_email hasn't been sent.
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
        # Send ecr_processed email and update ecr processed_confirmation_email attribute to true if
        # processed_confirmation_email hasn't been sent and ecr status is 1 ("completed")
        #
        # if !(@enrollment_change_request.processed_confirmation_email?) && @enrollment_change_request.status == 1
        #   EnrollmentChangeMailer::ecr_received(@enrollment_change_request).deliver
        #   email_notice = "Email confirmation sent."
        # else
        #   email_notice = ""
        # end

        format.html { redirect_to @enrollment_change_request, notice: 'Enrollment change request was successfully updated.' + email_notice }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @enrollment_change_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def email
    @user =  User.find(params[:parent_id])
    @student =  Student.find(params[:student_id])

    result = EnrollmentChangeMailer::enrollment_change_request(@user, @student).deliver
    if result
      redirect_to :back, notice: "Enrollment change request sent to #{@user.full_name}, for #{@student.full_name}."
    else
      redirect_to :back, notice: "Something must have gone wrong. Check the user's email and resend."
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
