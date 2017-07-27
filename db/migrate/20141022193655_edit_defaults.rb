class EditDefaults < ActiveRecord::Migration
  def change
    change_column :registrations, :switch, :boolean, :default => false
    change_column :opportunities, :interest_level, :integer, :default => 0
  end
end
