class CreateBadgeRequests < ActiveRecord::Migration
  def change
    create_table :badge_requests do |t|
      t.integer :badge_id
      t.integer :student_id
      t.boolean :parent_submission, default: false
      t.boolean :approved,          default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
