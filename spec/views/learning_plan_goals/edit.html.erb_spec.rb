require 'rails_helper'

RSpec.describe "learning_plan_goals/edit", type: :view do
  before(:each) do
    @learning_plan_goal = assign(:learning_plan_goal, LearningPlanGoal.create!(
      :name => "MyString",
      :completed => false
    ))
  end

  it "renders the edit learning_plan_goal form" do
    render

    assert_select "form[action=?][method=?]", learning_plan_goal_path(@learning_plan_goal), "post" do

      assert_select "input#learning_plan_goal_name[name=?]", "learning_plan_goal[name]"

      assert_select "input#learning_plan_goal_completed[name=?]", "learning_plan_goal[completed]"
    end
  end
end
