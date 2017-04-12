class BindersController < ActionController::Base
  before_action :authenticate_user!
  before_action :authorize_employee

  def briefcase
    @student = Student.find(params[:student_id])
    @offering = Offering.find(params[:offering_id])
  end

# Sets instance variable for student offering, used to print binder for
# middle school and brain builder classes.
  def middleschool
    @student = Student.find(params[:student_id])
    @offering = Offering.find(params[:offering_id])
  end

  private

  def authorize_employee
    root_path(subdomain: current_company.subdomain) unless current_user && current_user.employee?
  end
end
