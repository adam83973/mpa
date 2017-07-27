require 'rails_helper'

RSpec.describe "learning_plan_issues/index", type: :view do
  before(:each) do
    assign(:learning_plan_issues, [
      LearningPlanIssue.create!(
        :title => "Title"
      ),
      LearningPlanIssue.create!(
        :title => "Title"
      )
    ])
  end

  it "renders a list of learning_plan_issues" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
