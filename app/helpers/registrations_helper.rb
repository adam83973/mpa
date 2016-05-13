module RegistrationsHelper
  def registration_status(registration)
    case registration.status
    when 0
      if registration.switch
        "<span class='label label-default'>Switch</span>".html_safe
      else
        "<span class='label label-default'>New</span>".html_safe
      end
    when 1
      "<span class='label label-success'>Active</span>".html_safe
    when 2
      "<span class='label label-warning'>Hold</span>".html_safe
    when 3
      "<span class='label label-danger'>Inactive</span>".html_safe
    end
  end
end
