class AddLastPaymentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_payment, :string
  end
end
