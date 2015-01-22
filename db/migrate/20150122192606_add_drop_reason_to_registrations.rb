class AddDropReasonToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :drop_reason, :integer
  end
end
