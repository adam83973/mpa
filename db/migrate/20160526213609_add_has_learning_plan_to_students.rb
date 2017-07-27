class AddHasLearningPlanToStudents < ActiveRecord::Migration
  def change
    add_column :students, :has_learning_plan, :boolean, default: false
  end
end
