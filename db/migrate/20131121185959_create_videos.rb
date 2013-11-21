class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :url
      t.integer :lesson_id

      t.timestamps
    end
  end
end
