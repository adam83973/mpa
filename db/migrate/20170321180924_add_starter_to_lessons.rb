class AddStarterToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :starter, :text, default: ""
  end
end
