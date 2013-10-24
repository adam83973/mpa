class RemoveLessonsFromActivitiesLesson < ActiveRecord::Migration
  def up
    remove_column :activities_lessons, :lessons
  end

  def down
    add_column :activities_lessons, :lessons, :integer
  end
end
