class AddImageToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :image, :string
  end
end
