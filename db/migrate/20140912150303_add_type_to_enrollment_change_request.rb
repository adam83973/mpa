class AddTypeToEnrollmentChangeRequest < ActiveRecord::Migration
  def change
    add_column :enrollment_change_requests, :type, :integer
  end
end
