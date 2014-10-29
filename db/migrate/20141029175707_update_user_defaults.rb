class UpdateUserDefaults < ActiveRecord::Migration
  def change
    change_column :users, :balance_due, :integer, :default => 0
  end
end
