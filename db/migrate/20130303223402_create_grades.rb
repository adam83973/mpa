class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :student_id
      t.integer :course_id
      t.integer :lesson_id
      t.boolean :assessment
      t.integer :score

      t.timestamps
    end
  end
end
