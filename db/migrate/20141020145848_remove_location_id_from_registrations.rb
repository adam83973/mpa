class RemoveLocationIdFromRegistrations < ActiveRecord::Migration
  def up
    remove_column :registrations, :location_id
  end

  def down
    add_column :registrations, :location_id, :integer
  end
end
