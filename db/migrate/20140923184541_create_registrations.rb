class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.date :start_date
      t.date :end_date
      t.date :hold_date
      t.date :trial_date
      t.boolean :attended_first_class
      t.boolean :attended_trial
      t.integer :student_id
      t.integer :offering_id
      t.integer :admin_id
      t.integer :status

      t.timestamps
    end
  end
end
