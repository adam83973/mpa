class AddLessonIdToActivitiesLesson < ActiveRecord::Migration
  def change
    add_column :activities_lessons, :lesson_id, :integer
  end
end
