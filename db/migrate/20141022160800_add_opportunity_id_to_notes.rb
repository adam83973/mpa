class AddOpportunityIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :opportunity_id, :integer
  end
end
