module StudentsHelper
  def student_status(student)
    case student.status
    when "Active"
      "<span class='label label-success'>Active</span>"
    when "Hold"
      "<span class='label label-warning'>Hold</span>"
    else
      "<span class='label label-danger'>Inactive</span>"
    end
  end
end
