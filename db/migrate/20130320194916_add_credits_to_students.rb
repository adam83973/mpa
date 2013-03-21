class AddCreditsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :credits, :integer
  end
end
