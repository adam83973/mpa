class AddLocationIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :location_id, :integer
  end
end
