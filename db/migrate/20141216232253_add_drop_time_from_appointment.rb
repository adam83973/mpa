class AddDropTimeFromAppointment < ActiveRecord::Migration
  def change
    remove_column :appointments, :time
    add_column :appointments, :time, :datetime
  end
end
