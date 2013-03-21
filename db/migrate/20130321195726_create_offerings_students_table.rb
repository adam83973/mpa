class CreateOfferingsStudentsTable < ActiveRecord::Migration
  def up
  	create_table :offerings_students, :id => false do |t|
        t.integer :offering_id
      	t.integer :student_id
    end
    add_index :offerings_students, [:student_id, :offering_id]
  end

  def down
  	drop_table :offerings_students
  end
end
