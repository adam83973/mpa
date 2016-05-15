require 'rails_helper'

RSpec.describe "attendances/edit", type: :view do

  let(:attendance){FactoryGirl.create(:attendance)}

  before(:each) do
    @attendance = assign(:attendance, attendance)
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
