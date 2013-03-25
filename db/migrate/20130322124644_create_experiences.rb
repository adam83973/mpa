class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :name
      t.string :category
      t.text :content

      t.timestamps
    end
  end
end
