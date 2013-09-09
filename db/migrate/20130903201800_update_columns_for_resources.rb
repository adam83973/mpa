class UpdateColumnsForResources < ActiveRecord::Migration
  def change
  	add_column :resources, :file, :string
  	#remove_column :resources, :resource, :string
  end
end
