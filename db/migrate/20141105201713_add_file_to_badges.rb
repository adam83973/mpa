class AddFileToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :file, :string
  end
end
