class HelpSession
  def initialize(session)
    @session = session
    @session[:student_id] ||= nil
    @session[:user_id] ||= nil
    @session[:date] ||= nil
    @session[:location_id] ||= nil
    @session[:appointment_id] ||= nil
  end

  def add_student(student)
    @session[:student_id] = student.id
  end

  def add_user_id(user)
    @session[:user_id] = user.id
  end

  def add_date
    @session[:date] = Date.today
  end

  def add_location_id(location)
    @session[:location_id] = location.id
  end

  def add_appointment_id(appointment)
    @session[:appointment_id] = appointment.id
  end

  def in_help_session?
    if @session[:student_id] == nil
      false
    else
      true
    end
  end

  def student_id
    @session[:student_id]
  end

  def user_id
    @session[:user_id]
  end

  def date
    @session[:date]
  end

  def location_id
    @session[:location_id]
  end

  def appointment_id
    @session[:appointment_id]
  end

  def end_help_session
    @session[:student_ids] = nil
    @session[:week] = nil
    @session[:offering] = nil
  end
end
