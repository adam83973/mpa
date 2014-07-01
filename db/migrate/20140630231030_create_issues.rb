class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :name
      t.text :summary
      t.integer :user_id
      t.integer :priority
      t.boolean :resolved, default: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
