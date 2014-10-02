module StudentsHelper
  def student_status(student)
    if student.registrations.any? { |reg| reg.status == 1 }
      "<span class='label label-success'>Active</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 2 }
      "<span class='label label-warning'>Hold</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 3 }
      "<span class='label label-waitlist'>Waitlisted</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 0 }
      "<span class='label label-trial'>Hold</span>"
    else
      "<span class='label label-danger'>Inactive</span>"
    end
  end
end
