class AddFirstEmailReminderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_email_reminder, :boolean, default: false
  end
end
