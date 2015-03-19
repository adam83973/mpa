class AddAppointmentRescheduledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :appointment_rescheduled, :boolean, default: false
  end
end
