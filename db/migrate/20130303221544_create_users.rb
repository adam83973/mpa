class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :roll
      t.string :phone
      t.string :passion
      t.string :shirt_size
      t.boolean :has_key
      t.string :location
      t.string :address
      t.boolean :admin
      t.boolean :active

      t.timestamps
    end
  end
end
