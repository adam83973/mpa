class CreateBadgesStudents < ActiveRecord::Migration
  def change
    create_table :badges_students, :id => false do |t|
      t.integer :badge_id
      t.integer :student_id
    end
    add_index :badges_students, [:badge_id, :student_id]
  end
end
