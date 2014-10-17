class AddSwitchToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :switch, :boolean
  end
end
