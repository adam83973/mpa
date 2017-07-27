class AddRequirementsToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :requirements, :text
  end
end
