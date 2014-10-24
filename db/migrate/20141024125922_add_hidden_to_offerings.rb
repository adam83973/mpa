class AddHiddenToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :hidden, :boolean
  end
end
