class LessonsProblems < ActiveRecord::Migration
  def up
    create_table :lessons_problems, :id => false do |t|
      t.column :lesson_id, :integer
      t.column :problem_id, :integer
    end
  end
end