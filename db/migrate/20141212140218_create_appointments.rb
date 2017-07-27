class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :locationId
      t.integer :location_id
      t.integer :reasonId
      t.integer :clientId
      t.integer :user_id
      t.time :time

      t.timestamps
    end
  end
end
