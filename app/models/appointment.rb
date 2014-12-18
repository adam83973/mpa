class Appointment < ActiveRecord::Base
  attr_accessible :clientId, :locationId, :location_id, :reasonId, :time, :user_id, :calendarId, :visitMinutes, :note, :status, :hwHelpStudentName, :hwHelpClass, :hwHelpReason

  belongs_to :user
end