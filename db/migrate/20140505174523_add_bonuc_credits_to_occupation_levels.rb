class AddBonucCreditsToOccupationLevels < ActiveRecord::Migration
  def change
    add_column :occupation_levels, :bonus_credits, :integer, default: 0
  end
end
