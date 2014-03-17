class DailyLocationReport < ActiveRecord::Base
  attr_accessible :add_count, :drop_count, :location_id, :parent_logins, :total_enrollment

  belongs_to :location
end
