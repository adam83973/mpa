class AddGradeIdToExperiencePoints < ActiveRecord::Migration
  def change
    add_column :experience_points, :grade_id, :integer
  end
end
