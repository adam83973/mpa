class AddInterestLevelToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :interest_level, :integer
  end
end
