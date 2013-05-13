class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :name, :null => false
      t.string :category, :null => false
      t.text :content, :default => ""

      t.timestamps
    end
  end
end
