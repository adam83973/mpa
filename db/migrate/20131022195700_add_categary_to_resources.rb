class AddCategaryToResources < ActiveRecord::Migration
  def change
    add_column :resources, :category, :string
  end
end