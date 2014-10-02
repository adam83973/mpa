module RegistrationsHelper
  def registration_status(registration)
    case registration.status
    when 0
      "<span class='label label-success'>Active</span>"
    when 1
      "<span class='label label-warning'>Hold</span>"
    when 2
      "<span class='label label-danger'>Inactive</span>"
    when 3
      "<span class='label label-success'>New</span>"
    end
  end
end
