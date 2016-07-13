class AddEncryptedAttribtuesToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_ssn, :string
    add_column :users, :encrypted_ssn_iv, :string
    add_column :users, :encrypted_bank_account, :string
    add_column :users, :encrypted_bank_account_iv, :string
    add_column :users, :encrypted_routing_number, :string
    add_column :users, :encrypted_routing_number_iv, :string
  end
end
