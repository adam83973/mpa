class AddTimetapLocationIdToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :timetap_location_id, :integer
  end
end
