class UpdateAttributesForMessages < ActiveRecord::Migration
  def change
    change_column :messages, :read, :boolean, :default => false
    change_column :messages, :important, :boolean, :default => false
    add_column :messages, :general, :boolean
  end
end
