class AddUpdatedByToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :updated_by, :integer
  end
end
