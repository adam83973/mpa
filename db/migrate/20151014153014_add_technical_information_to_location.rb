class AddTechnicalInformationToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :technical_information, :text
  end
end
