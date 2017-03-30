class AddAttendanceFlagAndCourseIdToExperience < ActiveRecord::Migration[5.0]
  def change
    add_column :experiences, :attendance, :boolean, default: false
    add_column :experiences, :course_id, :integer
  end
end
