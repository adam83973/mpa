class RemoveAssesmentFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :assesment
  end

  def down
    add_column :lessons, :assesment, :text
  end
end
