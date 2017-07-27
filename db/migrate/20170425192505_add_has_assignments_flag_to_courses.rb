class AddHasAssignmentsFlagToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :has_assignments, :boolean, default: false
  end
end
