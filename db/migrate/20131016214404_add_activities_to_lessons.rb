class AddActivitiesToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :activities, :text
  end
end
