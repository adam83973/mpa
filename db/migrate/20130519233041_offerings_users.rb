class OfferingsUsers < ActiveRecord::Migration
  def up
    create_table :offerings_users, :id => false do |t|
        t.integer :offering_id
        t.integer :user_id
    end
    add_index :offerings_users, [:user_id, :offering_id]
  end

  def down
    drop_table :offerings_users
  end
end