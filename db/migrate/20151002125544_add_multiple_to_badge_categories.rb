class AddMultipleToBadgeCategories < ActiveRecord::Migration
  def change
    add_column :badge_categories, :multiple, :boolean, default: false
  end
end
