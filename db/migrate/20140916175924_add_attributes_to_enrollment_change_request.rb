class AddAttributesToEnrollmentChangeRequest < ActiveRecord::Migration
  def change
    add_column :enrollment_change_requests, :submission_confirmation_email, :boolean, default: false
    add_column :enrollment_change_requests, :processed_confirmation_email, :boolean, default: false
  end
end
