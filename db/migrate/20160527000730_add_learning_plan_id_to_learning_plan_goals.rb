class AddLearningPlanIdToLearningPlanGoals < ActiveRecord::Migration
  def change
    add_column :learning_plan_goals, :learning_plan_id, :integer
  end
end
