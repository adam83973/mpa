class RemoveTimeFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :time
  end

  def down
    add_column :locations, :time, :time
  end
end
