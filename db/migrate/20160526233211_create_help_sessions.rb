class CreateHelpSessions < ActiveRecord::Migration
  def change
    create_table :help_sessions do |t|
      t.date :date
      t.integer :user_id
      t.integer :learning_plan_id
      t.text :comments
      t.text :parent_feedback
      t.integer :student_id

      t.timestamps null: false
    end
  end
end
