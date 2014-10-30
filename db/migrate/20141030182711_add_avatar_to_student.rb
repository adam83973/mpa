class AddAvatarToStudent < ActiveRecord::Migration
  def change
    add_column :students, :avatar_id, :integer, default: 0
    add_column :students, :avatar_background_color, :string, default: "#ffffff"
  end
end
