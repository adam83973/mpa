class ProblemsStandards < ActiveRecord::Migration
  def change
    create_table :problems_standards, :id => false do |t|
    	t.integer :problem_id
    	t.integer :standard_id
    end
  end
end
