class AddSwitchIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :switch_id, :integer
  end
end
