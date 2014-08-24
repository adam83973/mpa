class AddDefaultToActiveLeads < ActiveRecord::Migration
  def change
    change_column :leads, :active, :boolean, :default => false
  end
end
