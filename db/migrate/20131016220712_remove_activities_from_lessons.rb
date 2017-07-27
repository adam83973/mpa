class RemoveActivitiesFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :activities
  end

  def down
    add_column :lessons, :activities, :text
  end
end
