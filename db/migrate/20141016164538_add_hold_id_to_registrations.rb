class AddHoldIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :hold_id, :integer
  end
end
