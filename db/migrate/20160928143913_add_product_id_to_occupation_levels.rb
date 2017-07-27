class AddProductIdToOccupationLevels < ActiveRecord::Migration
  def change
    add_column :occupation_levels, :product_id, :integer
  end
end
