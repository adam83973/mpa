class AddOccupationExperiencePointsToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :mathematician_experience_points, :integer, default: 0
    add_column :students, :engineer_experience_points, :integer, default: 0
    add_column :students, :programming_experience_points, :integer, default: 0
  end
end
