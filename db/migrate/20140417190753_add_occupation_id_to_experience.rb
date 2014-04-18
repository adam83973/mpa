class AddOccupationIdToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :occupation_id, :integer
  end
end
