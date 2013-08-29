class ProblemsStrategies < ActiveRecord::Migration
  def change
    create_table :problems_strategies, :id => false do |t|
    	t.integer :problem_id
    	t.integer :strategy_id
    end
    add_index :problems_strategies, [:problem_id, :strategy_id]
  end
end