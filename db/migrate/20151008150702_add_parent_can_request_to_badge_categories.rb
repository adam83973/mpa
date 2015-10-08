class AddParentCanRequestToBadgeCategories < ActiveRecord::Migration
  def change
    add_column :badge_categories, :parent_can_request, :boolean, default: true
  end
end
