module StudentsHelper
  def student_status(student)
    case student.status
    when "Active"
      "<span class='label label-success pull-right'>Active</span>"
    when "Hold"
      "<span class='label label-warning pull-right'>Hold</span>"
    else
      "<span class='label label-important pull-right'>Inactive</span>"
    end
  end
end
