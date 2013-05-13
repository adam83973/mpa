class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.integer :course_id, :null => false
      t.integer :location_id, :null => false
      t.string :day, :null => false
      t.time :time, :null => false
      t.integer :user_id, :null => false
      t.string :graduation_year
      t.text :comments

      t.timestamps
    end
  end
end
