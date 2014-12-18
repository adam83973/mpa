class AddHwHelpFieldsToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :hwHelpChild, :string
    add_column :appointments, :hwHelpClass, :string
    add_column :appointments, :hwHelpReason, :text
  end
end
