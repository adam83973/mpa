class FixStudentLevelAttributes < ActiveRecord::Migration
  def change
    rename_column :students, :robotics_level, :eng_level

    add_column :students, :prog_level, :integer, default: 0
  end
end
