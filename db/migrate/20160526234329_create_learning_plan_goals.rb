class CreateLearningPlanGoals < ActiveRecord::Migration
  def change
    create_table :learning_plan_goals do |t|
      t.string :name, null: false
      t.boolean :completed, default: false

      t.timestamps null: false
    end
  end
end
