class AddIndeciesToANumberOfTables < ActiveRecord::Migration
  def change
    add_index :assignments, :student_id
    add_index :appointments, :location_id
    add_index :badge_requests, :student_id
    add_index :offerings, :location_id
    add_index :offerings, :course_id
    add_index :experience_points, :student_id
    add_index :notes, :user_id
    add_index :registrations, :student_id
    add_index :registrations, :offering_id
    add_index :opportunities, :location_id
  end
end
