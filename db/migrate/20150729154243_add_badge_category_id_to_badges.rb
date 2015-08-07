class AddBadgeCategoryIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :badge_category_id, :integer
  end
end
