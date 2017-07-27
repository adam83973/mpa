class AddSpecializationToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :specialization, :boolean, default: false
  end
end
