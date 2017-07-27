class AddDefaultToHiddenOffering < ActiveRecord::Migration
  def change
    change_column :offerings, :hidden, :boolean, :default => false
  end
end
