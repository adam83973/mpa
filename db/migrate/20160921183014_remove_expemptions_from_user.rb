class RemoveExpemptionsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :expemptions, :integer
    add_column :users, :exemptions, :string, default: ''
  end
end
