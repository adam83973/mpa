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

  def user_status(user)
    case user.active
    when true
      "<span class='badge badge-success'>Active</span>"\
    else
      "<span class='badge badge-danger'>Inactive</span>"
    end
  end
end
