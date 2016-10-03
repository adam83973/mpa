class UpdateBirthDateToUsers < ActiveRecord::Migration
  def change
    change_column :users, :birth_date, :date
  end
end
