class AddRoboticsLevelToStudent < ActiveRecord::Migration
  def change
    add_column :students, :robotics_level, :integer, default: 0
  end
end
