class UpdateBadgeAttributesAndAddBannerHideToUsers < ActiveRecord::Migration
  def change
    change_column :badges, :multiple, :boolean, default: false
    add_column :users, :hide_badge_banner, :boolean, default: false
  end
end
