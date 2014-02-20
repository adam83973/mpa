class AddActiveToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :active, :boolean
  end
end
