module StudentsHelper
  def student_status(student)
    if student.registrations.any? { |reg| reg.status == 1 }
      "<span class='badge badge-success'>Active</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 2 }
      "<span class='badge badge-warning'>Hold</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 3 }
      "<span class='badge badge-waitlist'>Waitlisted</span>"
    elsif !(student.registrations.any? { |reg| reg.status == 1 }) && student.registrations.any? { |reg| reg.status == 0 }
      "<span class='badge badge-trial'>Hold</span>"
    else
      "<span class='badge badge-danger'>Inactive</span>"
    end
  end
end
