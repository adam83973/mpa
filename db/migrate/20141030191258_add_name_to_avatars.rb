class AddNameToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :name, :string
  end
end
