class CreateExperiencePoints < ActiveRecord::Migration
  def change
    create_table :experience_points do |t|
      t.integer :experience_id
      t.integer :points
      t.integer :student_id

      t.timestamps
    end
  end
end
