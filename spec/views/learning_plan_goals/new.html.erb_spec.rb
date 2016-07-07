require 'rails_helper'

RSpec.describe "learning_plan_goals/new", type: :view do
  before(:each) do
    assign(:learning_plan_goal, LearningPlanGoal.new(
      :name => "MyString",
      :completed => false
    ))
  end

  it "renders new learning_plan_goal form" do
    render

    assert_select "form[action=?][method=?]", learning_plan_goals_path, "post" do

      assert_select "input#learning_plan_goal_name[name=?]", "learning_plan_goal[name]"

      assert_select "input#learning_plan_goal_completed[name=?]", "learning_plan_goal[completed]"
    end
  end
end
