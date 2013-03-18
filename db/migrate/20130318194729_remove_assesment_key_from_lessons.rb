class RemoveAssesmentKeyFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :assesment_key
  end

  def down
    add_column :lessons, :assesment_key, :text
  end
end
