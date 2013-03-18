class AddAssesmentToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :assessment, :text
  end
end
