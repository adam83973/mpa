class AddMissedTrialToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :missed_trial, :boolean, default: false
  end
end
