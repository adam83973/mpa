class RemoveLastPaymentFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :last_payment
  end

  def down
    add_column :users, :last_payment, :string
  end
end
