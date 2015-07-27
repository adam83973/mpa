class AddDayNumberToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :day_number, :integer
  end
end
