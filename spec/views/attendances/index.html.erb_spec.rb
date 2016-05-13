require 'rails_helper'

RSpec.describe "attendances/index", type: :view do
  before(:each) do
    assign(:attendances, [
      Attendance.create!(
        :student_id => 1,
        :experience_point_id => 2,
        :offering_id => 3
      ),
      Attendance.create!(
        :student_id => 1,
        :experience_point_id => 2,
        :offering_id => 3
      )
    ])
  end

  it "renders a list of attendances" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
