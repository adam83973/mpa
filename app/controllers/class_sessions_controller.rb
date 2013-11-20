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
    @experience_points = @student.experience_points.where("experience_id = ? AND created_at = ?", 2, Date.today)
    @attendance_xp = @experience_points.last
    class_session.remove_student(params[:student_id])
      @attendance_xp.destroy

      redirect_to root_url, notice: "#{@student.first_name} was removed from class."
  end

  def end_class
    class_session.end_class
    redirect_to root_url
  end
end