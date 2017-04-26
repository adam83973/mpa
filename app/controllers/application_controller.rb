class ApplicationController < ActionController::Base
  protect_from_forgery

  around_action :scope_current_company
  around_action :scope_company_time_zone
  before_action :set_paper_trail_whodunnit
  before_action :authorize_active
  after_action  :set_access_control_headers
  force_ssl if: :ssl_configured?

  def authorize_active
    if signed_in?
      if !current_user.active?
        sign_out current_user
        redirect_to root_path(subdomain: current_company.subdomain), notice: "Your account is no longer active. If you feel you have received this message in error please contact your Center Director."
      end
    end
  end

  def authorize_admin
    redirect_to root_path(subdomain: current_company.subdomain), alert: "Not authorized." unless current_user && current_user.admin?
  end

  def verify_current_company
    if current_company.nil?
      redirect_to root_path(subdomain: "www"), alert: "Please select your location's application." unless request.subdomain == 'admin'
    end
  end

  def catch_www
    redirect_to root_path(subdomain: "www"), flash: { danger: 'You must select an application before trying to login.' }
  end

  def authorize_employee
    redirect_to root_path(subdomain: current_company.subdomain) unless current_user && current_user.employee?
  end

  def ssl_configured?
    !Rails.env.development? && !ENV['STAGING_APP']
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end

  private

  	def class_session
  	  @class_session ||= ClassSession.new(session)
  	end
  	helper_method :class_session

    def help_session
  	  @help_session ||= HelpSession.new(session)
  	end
  	helper_method :help_session

    def current_company
      @current_company ||= Company.find_by_subdomain(request.subdomain)
    end
    helper_method :current_company

    def scope_current_company(&block)
      if current_company.nil?
        yield
      else
        current_company.scope_schema("public", &block)
      end
    end

    def scope_company_time_zone(&block)
      if current_company.nil?
        yield
      else
        Time.use_zone(current_company.time_zone, &block)
      end
    end
end
