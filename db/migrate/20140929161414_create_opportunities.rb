class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.integer :registration_id
      t.integer :student_id
      t.integer :admin_id
      t.integer :offering_id
      t.boolean :attended_trial, default: false
      t.date :trial_date
      t.integer :status, default: 0
      t.date :possible_restart_date

      t.timestamps
    end
  end
end
