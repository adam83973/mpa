class BindersController < ActionController::Base

  def briefcase
    @student = Student.find(params[:student])

    if @student.offerings
      @offerings = @student.offerings.where("course_id < ?", 7)
      @first_offering = @offerings.first
    end
  end

  def middleschool
    @student = Student.find(params[:student])

    if @student.offerings
      @offerings = @student.offerings.where("course_id > ?", 6)
      @second_offering = @offerings.first
    end
  end
end

