class ApplicationController < ActionController::Base
  protect_from_forgery

  def authorize_admin
    redirect_to root_path, :flash => {:alert => "Insufficient rights!"} unless current_user && current_user.admin?
  end

  def authorize_employee
    redirect_to root_path unless current_user && current_user.employee?
  end

  private

	def class_session
	  @class_session ||= ClassSession.new(session)
	end
	helper_method :class_session

end
