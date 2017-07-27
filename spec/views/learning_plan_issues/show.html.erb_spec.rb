require 'rails_helper'

RSpec.describe "learning_plan_issues/show", type: :view do
  before(:each) do
    @learning_plan_issue = assign(:learning_plan_issue, LearningPlanIssue.create!(
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
