class Resourcings < ActiveRecord::Migration
  def change
  	create_table :resourcings do |t|
  		t.integer :resource_id
  		t.belongs_to :resourceable, polymorphic: true
  		t.timestamps
  	end
  end
  #add_index :resourcings, [:resourceable_id, :resourceable_type]
end
