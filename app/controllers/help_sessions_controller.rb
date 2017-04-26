class HelpSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee

  def new
  end

  def start_help_session
    @help_session = HelpSession.new(session)
    @help_session.add_date(params[:help_session][:date])
    @help_session.add_student_id(params[:help_session][:student_id])

    redirect_to  help_sessions_active_session_path(student_id: params[:help_session][:student_id])
  end

  def end_hw_help
    student = Student.find(help_session.student_id)
    user_id = help_session.user_id
    location_id = help_session.location_id
    date = help_session.date

    help_session.end_hw_help

    redirect_to new_help_session_record_path(student_id: student.id, user_id: user_id, location_id: location_id, date: date), notice: "Homework Help session ended. Please record the notes for this session."
  end

  def active_session
    @student = Student.find(params[:student_id])
    @registrations = @student.registrations.includes(offering: [:course, :location])
    @learning_plan = LearningPlan.new
    3.times{ @learning_plan.goals.build }

    respond_to do |format|
      format.html
      format.json { render json: @student }
    end
  end
end
