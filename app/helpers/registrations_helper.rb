module RegistrationsHelper
  def registration_status(registration)
    case registration.status
    when 0
      if registration.switch
        "<span class='badge badge-default'>Switch</span>".html_safe
      else
        "<span class='badge badge-default'>New</span>".html_safe
      end
    when 1
      "<span class='badge badge-success'>Active</span>".html_safe
    when 2
      "<span class='badge badge-warning'>Hold</span>".html_safe
    when 3
      "<span class='badge badge-danger'>Inactive</span>".html_safe
    end
  end
end
