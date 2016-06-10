class HelpSessionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  def new
  end

  def start_help_session
    @help_session = HelpSession.new(session)
    @help_session.add_date(params[:help_session][:date])
    @help_session.add_student_id(params[:help_session][:student_id])

    redirect_to  help_sessions_active_session_path(student_id: params[:help_session][:student_id])
  end

  def end_hw_help
    help_session.end_hw_help
    redirect_to root_url, notice: "Homework Help session ended."
  end

  def active_session
    @student = Student.find(params[:student_id])
    @learning_plan = LearningPlan.new
    3.times{ @learning_plan.goals.build }

    respond_to do |format|
      format.html
      format.json { render json: @student }
    end
  end
end
