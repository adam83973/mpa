class SchedulesController < ActionController::Base
  def powell
    @location = Location.includes(:offerings).find(1)
    @offerings = @location.offerings
  end

  def new_albany
    @location = Location.includes(:offerings).find(2)
    @offerings = @location.offerings
  end

  def mill_run
    @location = Location.includes(:offerings).find(3)
    @offerings = @location.offerings
  end
end
