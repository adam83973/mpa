class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name, :null => false, :default => ""
      t.string :last_name, :null => false, :default => ""
      t.date :birth_date
      t.date :start_date
      t.integer :offering_id, :null => false, :default => ""
      t.integer :parent_id, :null => false, :default => ""

      t.timestamps
    end
  end
end
