class ActivitiesLessons < ActiveRecord::Migration
  def change
    create_table :activities_lessons, :id => false do |t|
      t.integer :activity_id
      t.integer :lessons
    end
  end
end
