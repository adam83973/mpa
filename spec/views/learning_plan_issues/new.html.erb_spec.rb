require 'rails_helper'

RSpec.describe "learning_plan_issues/new", type: :view do
  before(:each) do
    assign(:learning_plan_issue, LearningPlanIssue.new(
      :title => "MyString"
    ))
  end

  it "renders new learning_plan_issue form" do
    render

    assert_select "form[action=?][method=?]", learning_plan_issues_path, "post" do

      assert_select "input#learning_plan_issue_title[name=?]", "learning_plan_issue[title]"
    end
  end
end
