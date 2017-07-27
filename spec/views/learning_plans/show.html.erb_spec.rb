require 'rails_helper'

RSpec.describe "learning_plans/show", type: :view do
  before(:each) do
    @learning_plan = assign(:learning_plan, LearningPlan.create!(
      :student_id => 1,
      :grade => "Grade",
      :course_id => 2,
      :learning_plan_issue_id => 3,
      :notes => "MyText",
      :strengths => "MyText",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Grade/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
