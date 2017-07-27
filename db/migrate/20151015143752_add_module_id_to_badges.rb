class AddModuleIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :module_id, :integer
  end
end
