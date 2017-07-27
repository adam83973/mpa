class AddCourseIdToOfferingHistory < ActiveRecord::Migration
  def change
    add_column :offering_histories, :course_id, :integer
  end
end
