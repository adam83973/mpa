class AddParentCanRequestToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :parent_can_request, :boolean, default: true
  end
end
