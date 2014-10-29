class AddBalanceDueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance_due, :integer
  end
end
