class ClassSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_employee

  def new
  end

  def start_class
    @class_session = ClassSession.new(session)
    @class_session.add_week(params[:class_session][:week])
    @class_session.add_offering_id(params[:class_session][:offering])

    redirect_to root_url(subdomain: current_company.subdomain)
  end

  def remove_student
    @student = Student.find(params[:student_id])

    # Find last attendance that corresponded with being added to class.
    @todays_attendance = Attendance.where(student_id: @student.id, date: Date.today).last
    # Delete attendance since student was removed from class.
    @todays_attendance.destroy if @todays_attendance

    class_session.remove_student(@student.id)
    redirect_to root_url(subdomain: current_company.subdomain), notice: "Student removed from class. Attendance was deleted."
  end

  def end_class
    class_session.end_class
    redirect_to root_url(subdomain: current_company.subdomain)
  end
end
