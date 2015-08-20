class AddWriteUpRequiredToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :write_up_required, :boolean, default: false
  end
end
