class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :nill => false
  end
end
