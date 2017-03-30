class AddAssignmentFlagToExperiences < ActiveRecord::Migration[5.0]
  def change
    add_column :experiences, :assignment, :boolean, default: false
  end
end
