require 'rails_helper'

RSpec.describe "learning_plans/index", type: :view do
  before(:each) do
    assign(:learning_plans, [
      LearningPlan.create!(
        :student_id => 1,
        :grade => "Grade",
        :course_id => 2,
        :learning_plan_issue_id => 3,
        :notes => "MyText",
        :strengths => "MyText"
      ),
      LearningPlan.create!(
        :student_id => 1,
        :grade => "Grade",
        :course_id => 2,
        :learning_plan_issue_id => 3,
        :notes => "MyText",
        :strengths => "MyText"
      )
    ])
  end

  it "renders a list of learning_plans" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Grade".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
