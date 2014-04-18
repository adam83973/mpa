class ChangePrevleges < ActiveRecord::Migration
  def change
    rename_column :occupation_levels, :prevleges, :privileges
  end
end
