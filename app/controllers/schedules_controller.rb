class SchedulesController < ActionController::Base
  def powell
    @powell = Location.find(1)
    @offerings = @powell.offerings
  end

  def new_albany
    @new_albany = Location.find(2)
    @offerings = @new_albany.offerings
  end
end