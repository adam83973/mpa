class DropSeveralAttributesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :ssn, :string
    remove_column :users, :bank_account, :string
    remove_column :users, :routing_number, :string
  end
end
