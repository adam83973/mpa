class AddOccupationLevelIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :occupation_level_id, :integer
  end
end
