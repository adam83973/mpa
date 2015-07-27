class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :user_id
      t.integer :recipient_id
      t.boolean :read
      t.boolean :important
      t.string :subject

      t.timestamps
    end
  end
end
