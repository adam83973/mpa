class AddExperiencePointToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :experience_point_id, :integer
  end
end
