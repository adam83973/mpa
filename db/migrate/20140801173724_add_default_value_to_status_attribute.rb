class AddDefaultValueToStatusAttribute < ActiveRecord::Migration
  def change
    change_column :students, :status, :string, :default => "Inactive"
  end
end
