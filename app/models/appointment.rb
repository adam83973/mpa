class Appointment < ActiveRecord::Base
  attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id, :calendarId, :visitMinutes, :note, :status, :hwHelpChild, :hwHelpClass, :hwHelpReason

  belongs_to :user
  belongs_to :location

  def update_location(check_appointment_location_id)
    ca_id = check_appointment_location_id
    if ca_id == 10935
        update_attribute :location_id, 1
    elsif ca_id == 10936
      update_attribute :location_id, 2
    elsif ca_id == 23402
      update_attribute :location_id, 3
    end
  end
end
