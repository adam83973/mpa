class RemoveParentFeedbackFromHelpSessionRecords < ActiveRecord::Migration
  def change
    remove_column :help_session_records, :parent_feedback, :text
  end
end
