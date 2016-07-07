class AddQuantityToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :quantity, :integer, default: 0
  end
end
