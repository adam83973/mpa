class AddOccupationIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :occupation_id, :integer
  end
end
