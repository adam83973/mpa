class CreateOfferingHistories < ActiveRecord::Migration
  def change
    create_table :offering_histories do |t|
      t.integer :offering_id
      t.integer :teacher_id
      t.integer :assistant_id
      t.integer :enrollment

      t.timestamps
    end
  end
end
