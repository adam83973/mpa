class BindersController < ActionController::Base

  def print
    @student = Student.find(params[:student])

    if @student.offerings
      @offerings = @student.offerings.where("course_id < ?", 7)
      @first_offering = @offerings.first
    end
  end
end

