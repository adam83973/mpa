class AddSystemAdminFlagToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :system_administrator, :boolean, default: false
  end
end
