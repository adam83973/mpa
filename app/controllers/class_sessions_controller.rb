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

    redirect_to root_url, notice: "Student removed from class. Be sure to delete attendace xp by going #{(view_context.link_to "here", @student).html_safe}."
  end

  def end_class
    class_session.end_class
    redirect_to root_url
  end
end
