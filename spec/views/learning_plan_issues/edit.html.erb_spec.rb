require 'rails_helper'

RSpec.describe "learning_plan_issues/edit", type: :view do
  before(:each) do
    @learning_plan_issue = assign(:learning_plan_issue, LearningPlanIssue.create!(
      :title => "MyString"
    ))
  end

  it "renders the edit learning_plan_issue form" do
    render

    assert_select "form[action=?][method=?]", learning_plan_issue_path(@learning_plan_issue), "post" do

      assert_select "input#learning_plan_issue_title[name=?]", "learning_plan_issue[title]"
    end
  end
end
