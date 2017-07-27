class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.integer :user_id
      t.integer :stage_id
      t.text :student_information

      t.timestamps
    end
  end
end
