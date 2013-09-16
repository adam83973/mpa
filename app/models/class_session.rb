class ClassSession
  def initialize(session)
    @session = session
    @session[:student_ids] ||= []
    @session[:week] = 12
    @session[:offering] = 2
  end

  def add_offering_id(offering)
  	@session[:offering] = offering.id
  end

  def add_student(student)
  	@session[:student_ids] << student.id
  end

  def add_week(week)
  	@session[:week] << week
  end

  def students
  	@session[:student_ids]
  end

  def week
  	@session[:week]
  end

  def offering
    @session[:offering]
  end
  def destroy
  	@session[:student_ids] = nil
  	@session[:week] = nil
  	@session[:offering] = nil
  end

end
