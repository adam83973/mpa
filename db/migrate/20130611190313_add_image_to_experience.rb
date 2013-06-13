class AddImageToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :image, :string
  end
end
