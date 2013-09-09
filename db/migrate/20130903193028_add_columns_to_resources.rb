class AddColumnsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :filename, :string
    add_column :resources, :content_type, :string
    add_column :resources, :file_size, :float
  end
end
