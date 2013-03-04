class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.date :start_date
      t.integer :offering_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
