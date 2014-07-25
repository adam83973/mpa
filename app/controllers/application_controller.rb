class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize_active

  def authorize_admin
    redirect_to root_path, :flash => {:alert => "Not authorized."} unless current_user && current_user.admin?
  end

  def authorize_employee
    redirect_to root_path unless current_user && current_user.employee?
  end

  def authorize_active
    if signed_in?
      if !current_user.active?
        sign_out current_user
        redirect_to root_path, flash: { alert:"Your account is no longer active. If you feel you have received this message in error please contact your Center Director."}
      end
    end
  end

  private

	def class_session
	  @class_session ||= ClassSession.new(session)
	end
	helper_method :class_session

end
