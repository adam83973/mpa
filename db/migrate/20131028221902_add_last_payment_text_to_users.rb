class AddLastPaymentTextToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_payment, :text
  end
end
