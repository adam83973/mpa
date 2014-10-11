class OpportunitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  # GET /opportunities
  # GET /opportunities.json
  def index
    @opportunities = Opportunity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opportunities }
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.json
  def show
    @opportunity = Opportunity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/new
  # GET /opportunities/new.json
  def new
    @opportunity = Opportunity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opportunity }
    end
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity = Opportunity.find(params[:id])
  end

  # POST /opportunities
  # POST /opportunities.json
  def create
    @opportunity = Opportunity.new(params[:opportunity])

    # Find possible users by searching for last name and email, removing duplicates
    @possible_users = User.where("last_name LIKE ? OR first_name LIKE ? OR email is ?", "%#{@opportunity.parent_name.split.last}%", "%#{@opportunity.parent_name.split.last}%", "#{@opportunity.parent_email}").order(:last_name )
    @possible_users = @possible_users.uniq

    respond_to do |format|
      if @opportunity.save
        if @opportunity.student
          format.html { redirect_to @opportunity.student, notice: 'Opportunity was successfully created.' }
          format.json { render json: @opportunity, status: :created, location: @opportunity }
          format.js
        else
          format.html { redirect_to root_url, notice: 'Opportunity was successfully created.' }
          format.json { render json: @opportunity, status: :created, location: @opportunity }
          format.js
        end
      else
        format.html { render action: "new" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /opportunities/1
  # PUT /opportunities/1.json
  def update
    @opportunity = Opportunity.find(params[:id])

    respond_to do |format|
      if @opportunity.update_attributes(params[:opportunity])
        format.html { redirect_to @opportunity, notice: 'Opportunity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to opportunities_url }
      format.json { head :no_content }
    end
  end

  def add_to_class
    @opportunity = Opportunity.find(params[:id])

    respond_to do |format|
      if @opportunity.student && @opportunity.offering
        # add code to create registration
        format.html { redirect_to @opportunity.student, notice: 'Opportunity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @opportunity.student, notice: 'Student and offering must be added in order to add student to a class. Click the edit button and make sure the opportunity is updated before adding to class.' }
        format.json { head :no_content }
      end
    end
  end

  def update_status
    @opportunity = Opportunity.find(params[:id])
    @old_status = @opportunity.status
    @new_status = params[:status]
    @note = Note.new
    @opportunity.update_status(@new_status.to_i)

    respond_to do |format|
      format.js
    end
  end

  def by_status
    @opportunities = Opportunity.where(status: params[:status])
    @status = params[:status]
    @note = Note.new

    respond_to do |format|
      format.js
    end
  end

  def add_parent
    @opportunity = Opportunity.find(params[:id])
    @user = User.find(params[:user_id])

    # Workflow takes user to possible students to add to opportunity once parent is added.
    @possible_students = Student.where("last_name LIKE ? OR first_name LIKE ? OR first_name LIKE ?", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.last}%", "%#{@opportunity.student_name.split.first}%").order(:last_name ).uniq

    respond_to do |format|
      if @opportunity.update_attribute(:user_id, params[:user_id].to_i)
        format.js
      end
    end
  end

  def add_student
    @opportunity = Opportunity.find(params[:id])
    @user = User.find(params[:student_id])

    respond_to do |format|
      if @opportunity.update_attribute(:student_id, params[:student_id].to_i)
        format.js
      end
    end
  end
end
