class AddMathLevelToStudents < ActiveRecord::Migration
  def change
    add_column :students, :math_level, :integer, default: 0
  end
end
