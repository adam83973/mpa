class AddMoreDefaultValuesToProducts < ActiveRecord::Migration
  def change
    change_column :products, :quantity, :integer, default: 0
    change_column :products, :name, :string, null: false
    change_column :products, :credits, :integer, default: 0
    change_column :products, :price, :integer, default: 0
  end
end
