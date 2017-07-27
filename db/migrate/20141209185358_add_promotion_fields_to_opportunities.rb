class AddPromotionFieldsToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :promotion_sent, :boolean
    add_column :opportunities, :promotion_id, :integer
  end
end
