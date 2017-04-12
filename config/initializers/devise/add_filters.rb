module DeviseFilters
  def self.add_filters
    # Example of adding a before_action to all the Devise controller
    # actions we care about.
    Devise::SessionsController.before_action :verify_current_company

      # Example of adding one selective before_action.
      # Devise::RegistrationsController.before_action
      #   :check_invite_code, :only => :new
      # end
  end
end
