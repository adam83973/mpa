class AddSourceToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :source, :string
  end
end
