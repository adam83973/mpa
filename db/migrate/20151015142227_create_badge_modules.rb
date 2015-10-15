class CreateBadgeModules < ActiveRecord::Migration
  def change
    create_table :badge_modules do |t|
      t.string :name, :null => false, :default => ""
      t.integer :badge_category_id

      t.timestamps
    end
  end
end
