class AddXpTotalToStudent < ActiveRecord::Migration
  def change
    add_column :students, :xp_total, :integer
  end
end
