class AddLocationIdToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :location_id, :integer
  end
end
