class AddAssessmentKeyToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :assessment_key, :text
  end
end
