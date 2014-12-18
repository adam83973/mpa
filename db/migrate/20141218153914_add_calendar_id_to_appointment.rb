class AddCalendarIdToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :calendarId, :integer
  end
end
