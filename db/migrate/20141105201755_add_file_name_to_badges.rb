class AddFileNameToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :file_name, :string
  end
end
