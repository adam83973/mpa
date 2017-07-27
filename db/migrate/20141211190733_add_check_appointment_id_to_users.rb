class AddCheckAppointmentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :check_appointments_id, :integer
  end
end
