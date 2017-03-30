class ChangeProgrammingExperiencePointsColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :students, :programming_experience_points, :programmer_experience_points
  end
end
