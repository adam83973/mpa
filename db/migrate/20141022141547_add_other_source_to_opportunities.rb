class AddOtherSourceToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :other_source, :string
  end
end
