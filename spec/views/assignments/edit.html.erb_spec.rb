require 'rails_helper'

RSpec.describe "assignments/edit", type: :view do
  before(:each) do
    @assignment = assign(:assignment, Assignment.create!(
      :student_id => 1,
      :score => 1,
      :corrected => false,
      :user_id => 1,
      :week => 1,
      :offering_id => 1
    ))
  end

  it "renders the edit assignment form" do
    render

    assert_select "form[action=?][method=?]", assignment_path(@assignment), "post" do

      assert_select "input#assignment_student_id[name=?]", "assignment[student_id]"

      assert_select "input#assignment_score[name=?]", "assignment[score]"

      assert_select "input#assignment_corrected[name=?]", "assignment[corrected]"

      assert_select "input#assignment_user_id[name=?]", "assignment[user_id]"

      assert_select "input#assignment_week[name=?]", "assignment[week]"

      assert_select "input#assignment_offering_id[name=?]", "assignment[offering_id]"
    end
  end
end
