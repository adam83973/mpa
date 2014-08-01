class AddStartHoldDateToStudent < ActiveRecord::Migration
  def change
    add_column :students, :start_hold_date, :date
  end
end
