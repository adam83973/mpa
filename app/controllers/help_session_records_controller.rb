class HelpSessionRecordsController < ApplicationController
  before_action :set_help_session_record, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :authorize_employee

  # GET /help_session_records
  def index
    @help_session_records = HelpSessionRecord.all
  end

  # GET /help_session_records/1
  def show
  end

  # GET /help_session_records/new
  def new
    @help_session_record = HelpSessionRecord.new
    if params[:student_id]
      @student = Student.find(params[:student_id])
    end
  end

  # GET /help_session_records/1/edit
  def edit
  end

  # POST /help_session_records
  def create
    @help_session_record = HelpSessionRecord.new(help_session_record_params)
    student = Student.find(help_session_record_params[:student_id])

    if @help_session_record.save
      redirect_to student, notice: 'Help session record was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /help_session_records/1
  def update
    if @help_session_record.update(help_session_record_params)
      redirect_to @help_session_record, notice: 'Help session record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /help_session_records/1
  def destroy
    @help_session_record.destroy
    redirect_to help_session_records_url, notice: 'Help session record was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help_session_record
      @help_session_record = HelpSessionRecord.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def help_session_record_params
      params.require(:help_session_record).permit(:student_id, :user_id, :date, :learning_plan_id, :comments, :session_length)
    end
end
