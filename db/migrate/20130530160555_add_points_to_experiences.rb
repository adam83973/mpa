class AddPointsToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :points, :integer
  end
end
