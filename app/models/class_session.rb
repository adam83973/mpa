class ClassSession
  def initialize(session)
    @session = session
    @session[:student_ids] ||= []
    @session[:week] ||= nil
    @session[:offering] ||= nil
  end

  def add_offering_id(offering)
    # offering is hash. e.g. {"id"=>"1"}
    @session[:offering] = offering.to_i
  end

  def add_student(student)
    @session[:student_ids] << student.id
  end

  def remove_student(student_id)
      @session[:student_ids].delete_at(@session[:student_ids].index(student_id.to_i) || @session[:student_ids].length)
  end

  def in_session?
    if @session[:student_ids] == [] && @session[:week] == nil && @session[:offering] == nil
      false
    else
      true
    end
  end

  def add_week(week)
    @session[:week] = week
  end

  def students
    @session[:student_ids]
  end

  def week
    @session[:week]
  end

  def week?
    if @session[:student_ids] == !nil
      true
    else
      false
    end
  end

  def offering
    @session[:offering]
  end

  def end_class
    @session[:student_ids] = nil
    @session[:week] = nil
    @session[:offering] = nil
  end

end
