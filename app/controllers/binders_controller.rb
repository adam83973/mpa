class BindersController < ActionController::Base
  before_action :authorize_employee
  around_action :scope_current_company

  def current_company
    @current_company ||= Company.find_by_subdomain(request.subdomain)
  end

  def scope_current_company(&block)
    if current_company.nil?
      yield
    else
      current_company.scope_schema("public", &block)
    end
  end

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
    root_path unless current_user && current_user.employee?
  end
end
