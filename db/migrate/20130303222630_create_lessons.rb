class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :week
      t.integer :course_id
      t.text :assignment
      t.text :assignment_key
      t.text :assesment
      t.text :assesment_key

      t.timestamps
    end
  end
end
