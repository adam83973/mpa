class RemoveLevelFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :level
  end

  def down
    add_column :students, :level, :integer
  end
end
