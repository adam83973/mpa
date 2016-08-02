class AddCourseIdToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :course_id, :integer
    add_index :assignments, [:course_id, :week], unique: true
  end
end
