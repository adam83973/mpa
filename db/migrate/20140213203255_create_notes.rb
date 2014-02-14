class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :lead_id
      t.boolean :due
      t.date :due_date
      t.text :content

      t.timestamps
    end
  end
end
