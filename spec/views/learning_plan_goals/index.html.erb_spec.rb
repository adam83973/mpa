require 'rails_helper'

RSpec.describe "learning_plan_goals/index", type: :view do
  before(:each) do
    assign(:learning_plan_goals, [
      LearningPlanGoal.create!(
        :name => "Name",
        :completed => false
      ),
      LearningPlanGoal.create!(
        :name => "Name",
        :completed => false
      )
    ])
  end

  it "renders a list of learning_plan_goals" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
