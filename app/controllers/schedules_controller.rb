class SchedulesController < ActionController::Base
  def powell
    @location = Location.find(1)
    @offerings = @location.offerings
  end

  def new_albany
    @location = Location.find(2)
    @offerings = @location.offerings
  end
end