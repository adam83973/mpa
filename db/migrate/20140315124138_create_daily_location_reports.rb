class CreateDailyLocationReports < ActiveRecord::Migration
  def change
    create_table :daily_location_reports do |t|
      t.integer :location_id
      t.integer :parent_logins
      t.integer :drop_count
      t.integer :add_count

      t.timestamps
    end
  end
end
