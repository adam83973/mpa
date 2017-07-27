class AddNegativeToExperiencePoints < ActiveRecord::Migration
  def change
    add_column :experience_points, :negative, :boolean, default: false
  end
end
