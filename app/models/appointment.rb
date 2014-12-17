class Appointment < ActiveRecord::Base
  attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id

  belongs_to :user
end