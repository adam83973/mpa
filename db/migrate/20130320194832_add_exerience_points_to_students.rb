class AddExeriencePointsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :experience_points, :integer
  end
end
