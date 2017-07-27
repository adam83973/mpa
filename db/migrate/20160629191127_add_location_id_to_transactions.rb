class AddLocationIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :location_id, :integer
  end
end
