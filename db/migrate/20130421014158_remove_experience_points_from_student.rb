class RemoveExperiencePointsFromStudent < ActiveRecord::Migration
  def up
    remove_column :students, :experience_points
  end

  def down
    add_column :students, :experience_points, :integer
  end
end
