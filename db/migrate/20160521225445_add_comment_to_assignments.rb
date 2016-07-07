class AddCommentToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :comment, :text
  end
end
