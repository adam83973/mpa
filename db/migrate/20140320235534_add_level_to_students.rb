class AddLevelToStudents < ActiveRecord::Migration
  def change
    add_column :students, :level, :integer, :default => 1
  end
end
