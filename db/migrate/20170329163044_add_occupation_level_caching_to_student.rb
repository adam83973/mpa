class AddOccupationLevelCachingToStudent < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :engineer_level, :integer, default: 0
    add_column :students, :mathematician_level, :integer, default: 0
    add_column :students, :programmer_level, :integer, default: 0
    add_column :students, :experience_point_total, :integer, default: 0
  end
end
