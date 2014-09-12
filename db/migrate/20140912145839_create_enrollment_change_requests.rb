class CreateEnrollmentChangeRequests < ActiveRecord::Migration
  def change
    create_table :enrollment_change_requests do |t|
      t.integer :user_id
      t.integer :admin_id
      t.integer :status, default: 0
      t.date :hold_start_date
      t.date :hold_return_date
      t.date :end_date
      t.string :reason_ids
      t.text :other_reason
      t.boolean :restart_billing_authorization
      t.integer :student_id

      t.timestamps
    end
  end
end
