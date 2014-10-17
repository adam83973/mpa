module RegistrationsHelper
  def registration_status(registration)
    case registration.status
    when 0
      if registration.switch
        "<span class='label label-default'>Switch</span>"
      else
        "<span class='label label-default'>New</span>"
      end
    when 1
      "<span class='label label-success'>Active</span>"
    when 2
      "<span class='label label-warning'>Hold</span>"
    when 3
      "<span class='label label-danger'>Inactive</span>"
    end
  end
end
