class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :type, null: false
      t.integer :user_id, null: false
      t.integer :student_id, null: false
      t.integer :credits_redeemed

      t.timestamps null: false
    end
  end
end
