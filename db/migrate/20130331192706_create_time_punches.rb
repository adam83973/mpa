class CreateTimePunches < ActiveRecord::Migration
  def change
    create_table :time_punches do |t|
      t.datetime :in
      t.datetime :out
      t.string :comment
      t.boolean :modified, :default => false

      t.timestamps
    end
  end
end
