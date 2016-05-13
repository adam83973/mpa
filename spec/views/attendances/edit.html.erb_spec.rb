require 'rails_helper'

RSpec.describe "attendances/edit", type: :view do
  before(:each) do
    @attendance = assign(:attendance, Attendance.create!(
      :student_id => 1,
      :experience_point_id => 1,
      :offering_id => 1
    ))
  end

  it "renders the edit attendance form" do
    render

    assert_select "form[action=?][method=?]", attendance_path(@attendance), "post" do

      assert_select "input#attendance_student_id[name=?]", "attendance[student_id]"

      assert_select "input#attendance_experience_point_id[name=?]", "attendance[experience_point_id]"

      assert_select "input#attendance_offering_id[name=?]", "attendance[offering_id]"
    end
  end
end
