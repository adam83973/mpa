class AddCheckAppointmentIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :check_appointments_id, :integer
  end
end
