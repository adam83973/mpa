class AddMultipleToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :multiple, :boolean
  end
end
