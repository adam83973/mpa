class AddContainsErrorToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :contains_error, :boolean, default: false
  end
end
