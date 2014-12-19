class Appointment < ActiveRecord::Base
  attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id, :calendarId, :visitMinutes, :note, :status, :hwHelpChild, :hwHelpClass, :hwHelpReason

  belongs_to :user
  belongs_to :location

  def create_with_parent(appointment, parent)
    create!(
            clientId:      appointment['client']['clientId'],
            calendarId:    appointment['calendarid'],
            locationId:    appointment['location']['locationId'],
            reasonId:      appointment['reason']['reasonId'],
            visitMinutes:  appointment['reason']['visitMinutes'],
            time:          DateTime.parse(appointment['appointmentDateTimeClient']),
            user_id:       parent.id,
            note:          appointment['note'])
  end

  def update_hw_help_attributes(appointment)
    update_attributes({
            hwHelpChild:   appointment['customField1'],
            hwHelpClass:   appointment['customField2'],
            hwHelpReason:  appointment['customField3']})
  end
end