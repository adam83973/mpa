class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :student_id
      t.integer :experience_point_id
      t.date :date
      t.integer :offering_id

      t.timestamps null: false
    end
  end
end
