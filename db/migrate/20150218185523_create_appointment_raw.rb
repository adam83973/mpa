class CreateAppointmentRaw < ActiveRecord::Migration
  def change
    create_table :appointment_requests do |t|
      t.text :data

      t.timestamps
    end
  end
end
