class RemoveAttendedFristClassFromStudent < ActiveRecord::Migration
  def up
    remove_column :students, :attended_frist_class
  end

  def down
    add_column :students, :attended_frist_class, :boolean
  end
end
