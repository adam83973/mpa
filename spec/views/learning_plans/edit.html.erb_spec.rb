require 'rails_helper'

RSpec.describe "learning_plans/edit", type: :view do
  before(:each) do
    @learning_plan = assign(:learning_plan, LearningPlan.create!(
      :student_id => 1,
      :grade => "MyString",
      :course_id => 1,
      :learning_plan_issue_id => 1,
      :notes => "MyText",
      :strengths => "MyText"
    ))
  end

  it "renders the edit learning_plan form" do
    render

    assert_select "form[action=?][method=?]", learning_plan_path(@learning_plan), "post" do

      assert_select "input#learning_plan_student_id[name=?]", "learning_plan[student_id]"

      assert_select "input#learning_plan_grade[name=?]", "learning_plan[grade]"

      assert_select "input#learning_plan_course_id[name=?]", "learning_plan[course_id]"

      assert_select "input#learning_plan_learning_plan_issue_id[name=?]", "learning_plan[learning_plan_issue_id]"

      assert_select "textarea#learning_plan_notes[name=?]", "learning_plan[notes]"

      assert_select "textarea#learning_plan_strengths[name=?]", "learning_plan[strengths]"
    end
  end
end
