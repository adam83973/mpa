class CreateLearningPlanIssues < ActiveRecord::Migration
  def change
    create_table :learning_plan_issues do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
