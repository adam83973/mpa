class AddDefaultToActiveLeadsAgain < ActiveRecord::Migration
  def change
    change_column :leads, :active, :boolean, :default => true
  end
end
