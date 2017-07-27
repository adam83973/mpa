class DropUnusedTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :grades
    drop_table :leads
    # drop_table :time_punches
  end
end
