class HelpSessionsController < ApplicationController
  before_action :set_help_session, only: [:show, :edit, :update, :destroy]

  # GET /help_sessions
  def index
    @help_sessions = HelpSession.all
  end

  # GET /help_sessions/1
  def show
  end

  # GET /help_sessions/new
  def new
    @help_session = HelpSession.new
  end

  # GET /help_sessions/1/edit
  def edit
  end

  # POST /help_sessions
  def create
    @help_session = HelpSession.new(help_session_params)

    if @help_session.save
      redirect_to @help_session, notice: 'Help session was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /help_sessions/1
  def update
    if @help_session.update(help_session_params)
      redirect_to @help_session, notice: 'Help session was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /help_sessions/1
  def destroy
    @help_session.destroy
    redirect_to help_sessions_url, notice: 'Help session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help_session
      @help_session = HelpSession.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def help_session_params
      params.require(:help_session).permit(:date, :user_id, :learning_plan_id, :comments, :parent_feedback, :student_id)
    end
end
