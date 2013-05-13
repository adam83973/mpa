class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :roll
      t.string :phone, :null => false, :default => ""
      t.string :passion
      t.string :shirt_size
      t.boolean :has_key
      t.string :location, :null => false, :default => ""
      t.string :address
      t.boolean :admin
      t.boolean :active, :null => false, :default => true

      t.timestamps
    end
  end
end
