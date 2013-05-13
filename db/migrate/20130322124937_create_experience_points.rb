class CreateExperiencePoints < ActiveRecord::Migration
  def change
    create_table :experience_points do |t|
      t.integer :experience_id, :null => false
      t.integer :points, :null => false
      t.integer :student_id, :null => false

      t.timestamps
    end
  end
end
