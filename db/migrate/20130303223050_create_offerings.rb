class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.integer :course_id
      t.integer :location_id
      t.string :day
      t.time :time
      t.integer :user_id
      t.string :graduation_year
      t.text :comments

      t.timestamps
    end
  end
end
