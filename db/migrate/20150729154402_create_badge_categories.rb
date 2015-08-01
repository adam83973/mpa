class CreateBadgeCategories < ActiveRecord::Migration
  def change
    create_table :badge_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
