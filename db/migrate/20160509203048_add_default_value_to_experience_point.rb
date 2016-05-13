class AddDefaultValueToExperiencePoint < ActiveRecord::Migration
  def change
    change_column :experience_points, :negative, :boolean, :default => false
  end
end
