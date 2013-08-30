class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.string :desc
      t.string :strategies
      t.string :source
      t.string :answer
      t.string :methods
      t.string :variations

      t.timestamps
    end
  end
end
