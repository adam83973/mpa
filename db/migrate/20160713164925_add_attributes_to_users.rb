class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ssn, :text
    add_column :users, :bank_account, :text
    add_column :users, :routing_number, :text
  end
end
