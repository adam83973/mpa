class ClassSessionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_employee

  def new
  end

  def start_class
    @class_session = ClassSession.new(session)
    @class_session.add_week(params[:week])
    @class_session.add_offering_id(params[:offering])

    redirect_to root_url
  end

  def remove_student
    @student = Student.find(params[:student_id])
    @attendance_xp = @student.last_attendance_xp
    class_session.remove_student(params[:student_id])
    @attendance_xp.destroy
  end

  def end_class
    class_session.end_class
    redirect_to root_url
  end
end