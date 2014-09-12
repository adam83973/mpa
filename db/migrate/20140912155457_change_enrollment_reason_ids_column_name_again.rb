class ChangeEnrollmentReasonIdsColumnNameAgain < ActiveRecord::Migration
  def change
    rename_column :enrollment_change_requests, :reason_ids, :reason_id
  end
end
