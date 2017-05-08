class AddCompanyIdToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources,              :company_id, :integer
    add_column :avatars,                :company_id, :integer
    add_column :badges,                 :company_id, :integer
    add_column :experiences,            :company_id, :integer
    add_column :occupation_levels,      :company_id, :integer
  end
end
