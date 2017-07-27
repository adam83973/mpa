class AddFieldsToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :visitMinutes, :integer
    add_column :appointments, :note, :text
    add_column :appointments, :status, :string
  end
end
