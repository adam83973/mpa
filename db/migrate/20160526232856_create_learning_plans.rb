class CreateLearningPlans < ActiveRecord::Migration
  def change
    create_table :learning_plans do |t|
      t.integer :student_id
      t.string :grade
      t.integer :course_id
      t.integer :learning_plan_issue_id
      t.text :notes
      t.text :strengths

      t.timestamps null: false
    end
  end
end
