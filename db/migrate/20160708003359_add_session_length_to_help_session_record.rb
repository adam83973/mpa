class AddSessionLengthToHelpSessionRecord < ActiveRecord::Migration
  def change
    add_column :help_session_records, :session_length, :integer, default: 0
  end
end
