class AddOccupationIdToOccupationLevel < ActiveRecord::Migration
  def change
    add_column :occupation_levels, :occupation_id, :integer
  end
end
