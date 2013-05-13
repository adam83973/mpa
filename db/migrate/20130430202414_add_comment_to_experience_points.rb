class AddCommentToExperiencePoints < ActiveRecord::Migration
  def change
    add_column :experience_points, :comment, :text, :default => ""
  end
end
