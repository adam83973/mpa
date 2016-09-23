class AddReportFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :assignments_reports, :boolean, default: false
    add_column :users, :opportunities_reports, :boolean, default: false
  end
end
