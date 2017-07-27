class AddImageToOccupationLevels < ActiveRecord::Migration
  def change
    add_column :occupation_levels, :image, :string
  end
end
