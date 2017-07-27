class AddWriteUpRequiredToBadgeCategories < ActiveRecord::Migration
  def change
    add_column :badge_categories, :write_up_required, :boolean, default: false
  end
end
