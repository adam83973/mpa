class AddUserIdToLearningPlans < ActiveRecord::Migration
  def change
    add_column :learning_plans, :user_id, :integer
  end
end
