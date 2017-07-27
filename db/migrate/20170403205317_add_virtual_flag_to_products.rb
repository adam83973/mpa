class AddVirtualFlagToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :virtual, :boolean, default: false
  end
end
