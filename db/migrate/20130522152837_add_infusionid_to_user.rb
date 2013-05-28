class AddInfusionidToUser < ActiveRecord::Migration
  def change
    add_column :users, :infusion_id, :integer
  end
end
