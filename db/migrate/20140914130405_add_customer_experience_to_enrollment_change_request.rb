class AddCustomerExperienceToEnrollmentChangeRequest < ActiveRecord::Migration
  def change
    add_column :enrollment_change_requests, :customer_experience, :text
    add_column :enrollment_change_requests, :possible_return_date, :date
  end
end
