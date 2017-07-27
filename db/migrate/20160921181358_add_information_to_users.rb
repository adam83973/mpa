class AddInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string, default: ''
    add_column :users, :city, :string, default: ''
    add_column :users, :state, :string, default: ''
    add_column :users, :zip, :string, default: ''
    add_column :users, :expemptions, :integer
  end
end
