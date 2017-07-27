class CreateOccupationLevels < ActiveRecord::Migration
  def change
    create_table :occupation_levels do |t|
      t.integer :level
      t.integer :points
      t.text :rewards
      t.text :prevleges
      t.text :notes

      t.timestamps
    end
  end
end
