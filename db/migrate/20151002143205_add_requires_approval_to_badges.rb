class AddRequiresApprovalToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :requires_approval, :boolean, default: false
  end
end
