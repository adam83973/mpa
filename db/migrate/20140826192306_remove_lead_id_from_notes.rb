class RemoveLeadIdFromNotes < ActiveRecord::Migration
  def up
    remove_column :notes, :lead_id
  end

  def down
    add_column :notes, :lead_id, :integer
  end
end
