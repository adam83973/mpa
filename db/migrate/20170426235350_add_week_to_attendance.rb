class AddWeekToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :week, :integer
  end
end
