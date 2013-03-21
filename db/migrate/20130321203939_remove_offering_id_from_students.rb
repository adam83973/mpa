class RemoveOfferingIdFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :offering_id
  end

  def down
    add_column :students, :offering_id, :integer
  end
end
