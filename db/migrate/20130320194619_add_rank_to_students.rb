class AddRankToStudents < ActiveRecord::Migration
  def change
    add_column :students, :rank, :string
  end
end
