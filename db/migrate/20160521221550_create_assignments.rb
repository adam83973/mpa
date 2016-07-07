class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :student_id
      t.integer :score
      t.boolean :corrected, default: false
      t.integer :user_id
      t.integer :week
      t.integer :offering_id

      t.timestamps null: false
    end
  end
end
