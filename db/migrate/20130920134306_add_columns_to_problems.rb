class AddColumnsToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :activity_type, :string
    add_column :problems, :setup, :text
  end
end
