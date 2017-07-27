class ChangeFirstClassAttendedDefault < ActiveRecord::Migration
  def change
    change_column :students, :attended_first_class, :boolean, :default => false
  end
end
