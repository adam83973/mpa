class ActivitiesStandards < ActiveRecord::Migration
  def change
  	    create_table :activities_standards, :id => false do |t|
    	t.integer :activity_id
    	t.integer :standard_id
    end
  end
end
