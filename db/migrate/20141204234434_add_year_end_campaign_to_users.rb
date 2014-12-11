class AddYearEndCampaignToUsers < ActiveRecord::Migration
  def change
    add_column :users, :year_end_campaign, :boolean, default: false
  end
end
