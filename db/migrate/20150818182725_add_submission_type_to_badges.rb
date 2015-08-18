class AddSubmissionTypeToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :submission_type, :integer
  end
end
