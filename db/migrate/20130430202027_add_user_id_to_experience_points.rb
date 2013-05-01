class AddUserIdToExperiencePoints < ActiveRecord::Migration
  def change
    add_column :experience_points, :user_id, :integer
  end
end
