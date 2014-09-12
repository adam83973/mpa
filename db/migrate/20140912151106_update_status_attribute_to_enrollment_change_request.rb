class UpdateStatusAttributeToEnrollmentChangeRequest < ActiveRecord::Migration
  def change
    change_column :enrollment_change_requests, :status, :integer, :default => 0
  end
end
