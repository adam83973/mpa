class AddUniqueIndexToAssignments < ActiveRecord::Migration
  def change
    add_index :assignments, [:id, :course_id, :week], unique: true
    remove_index(:assignments, [:course_id, :week])
  end
end
