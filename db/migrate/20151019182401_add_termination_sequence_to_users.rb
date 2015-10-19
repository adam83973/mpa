class AddTerminationSequenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :termination_sequence, :boolean, default: false
  end
end
