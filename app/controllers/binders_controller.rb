class BindersController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :authorize_employee

  def briefcase
    @student = Student.find(params[:student])

# Sets instance variable for student offering, used to print binder
# for elementary classes.
    if @student.offerings
      @offerings = @student.offerings.where("course_id < ?", 7)
      @agent_offering = @offerings.first
    end
  end

# Sets instance variable for student offering, used to print binder for
# middle school and brain builder classes.
  def middleschool
    @student = Student.find(params[:student])

    if @student.offerings
      @offerings = @student.offerings.where("course_id > ?", 6)
      @second_offering = @offerings.first
    end
  end

  private

  def authorize_employee
    redirect_to root_path unless current_user && current_user.employee?
  end
end

