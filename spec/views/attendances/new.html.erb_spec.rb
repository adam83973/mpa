require 'rails_helper'

RSpec.describe "attendances/new", type: :view do
  before(:each) do
    assign(:attendance, Attendance.new(
      :student_id => 1,
      :experience_point_id => 1,
      :offering_id => 1
    ))
  end

  it "renders new attendance form" do
    render

    assert_select "form[action=?][method=?]", attendances_path, "post" do

      assert_select "input#attendance_student_id[name=?]", "attendance[student_id]"

      assert_select "input#attendance_experience_point_id[name=?]", "attendance[experience_point_id]"

      assert_select "input#attendance_offering_id[name=?]", "attendance[offering_id]"
    end
  end
end
