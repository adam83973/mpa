class AddCourseIdToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :course_id, :integer
  end
end
