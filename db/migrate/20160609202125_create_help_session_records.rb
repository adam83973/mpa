class CreateHelpSessionRecords < ActiveRecord::Migration
  def change
    create_table :help_session_records do |t|
      t.integer :student_id
      t.integer :user_id
      t.date :date
      t.integer :learning_plan_id
      t.text :comments
      t.text :parent_feedback

      t.timestamps null: false
    end
  end
end
