class AddUserIdToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :user_id, :string
    add_column :attendances, :integer, :string
  end
end
