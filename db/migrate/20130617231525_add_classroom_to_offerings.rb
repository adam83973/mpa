class AddClassroomToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :classroom, :string
  end
end
