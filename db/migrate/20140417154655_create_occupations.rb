class CreateOccupations < ActiveRecord::Migration
  def change
    create_table :occupations do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
