class SchedulesController < ActionController::Base
  around_action :scope_current_company
  
  def current_company
    @current_company ||= Company.find_by_subdomain(request.subdomain)
  end

  def scope_current_company(&block)
    if current_company.nil?
      yield
    else
      current_company.scope_schema("public", &block)
    end
  end

  def powell
    @location = Location.includes(:offerings).find(1)
    @offerings = @location.offerings.includes(:registrations)
  end

  def new_albany
    @location = Location.includes(:offerings).find(2)
    @offerings = @location.offerings.includes(:registrations)
  end

  def mill_run
    @location = Location.includes(:offerings).find(3)
    @offerings = @location.offerings.includes(:registrations)
  end
end
