class AddExperiendIdToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :experience_id, :integer
  end
end
