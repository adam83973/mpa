class AddAttributesToStudent < ActiveRecord::Migration
  def change
    add_column :students, :mathematics_xp, :integer, default: 0
    add_column :students, :engineering_xp, :integer, default: 0
    add_column :students, :programmer_xp, :integer, default: 0
  end
end
