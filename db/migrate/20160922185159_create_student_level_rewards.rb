class CreateStudentLevelRewards < ActiveRecord::Migration
  def change
    create_table :student_level_rewards do |t|
      t.integer :student_id, null: false
      t.integer :occupation_level_id, null: false

      t.timestamps null: false
    end
  end
end
