class AddDefaultValueToSatusAttribute < ActiveRecord::Migration
  def change
    change_column :issues, :status, :integer, :default => 0
  end
end
