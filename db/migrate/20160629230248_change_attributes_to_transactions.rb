class ChangeAttributesToTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :type, :integer
    add_column :transactions, :process, :integer
  end
end
