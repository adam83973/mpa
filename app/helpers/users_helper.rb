module UsersHelper

  def teacher_name_by_role(user)
    if user.role == "Teacher"
      user.full_name
    elsif user.role == "Programming Instructor"
      user.full_name
    elsif user.role == "Robotics Instructor"
      user.full_name
    elsif user.role == "Chess Instructor"
      user.full_name
    end
  end

  def open_spots(offering)
    if offering.course_id < 10
      10 - (offering.active_students_count + offering.returning_students_count)
    elsif [10].include?(offering.course_id)
      14 - (offering.active_students_count + offering.returning_students_count)
    elsif [11, 12].include?(offering.course_id)
      8 - (offering.active_students_count + offering.returning_students_count)
    elsif [13, 17].include?(offering.course_id)
      10 - (offering.active_students_count + offering.returning_students_count)
    elsif [15, 16, 18].include?(offering.course_id)
      8 - (offering.active_students_count + offering.returning_students_count)
    end
  end
end
