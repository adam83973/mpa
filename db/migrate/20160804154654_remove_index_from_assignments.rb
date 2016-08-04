class RemoveIndexFromAssignments < ActiveRecord::Migration
  def change
    remove_index :assignments, [:id, :course_id, :week]
  end
end
