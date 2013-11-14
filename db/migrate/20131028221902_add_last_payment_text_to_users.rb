class AddLastPaymentTextToUsers < ActiveRecord::Migration
  def change
    unless column_exists? :users, :last_payment
      add_column :users, :last_payment, :text
    end
  end
end
