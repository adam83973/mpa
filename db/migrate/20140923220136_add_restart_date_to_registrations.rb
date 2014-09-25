class AddRestartDateToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :restart_date, :date
  end
end
