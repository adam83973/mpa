class CreateResourcings < ActiveRecord::Migration
  def change
    create_table :resourcings do |t|

      t.timestamps
    end
  end
end
