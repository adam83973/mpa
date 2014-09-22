class AddAttendedFirstClassFromStudent < ActiveRecord::Migration
  def change
    add_column :students, :attended_first_class, :boolean
  end
end
