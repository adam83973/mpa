class DropHelpSession < ActiveRecord::Migration
  def change
    drop_table :help_sessions
  end
end
