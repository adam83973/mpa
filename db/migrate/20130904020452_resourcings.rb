class Resourcings < ActiveRecord::Migration
  def change
  	create_table :resourcings
  		t.integer :resource_id
  		t.belongs_to :resourceable, polymorphic: true
  		t.timestamps
  end
  add_index :resourcings, [:resourceable_id, :resourceable_type]
end
