require 'rails_helper'

RSpec.describe "learning_plan_goals/show", type: :view do
  before(:each) do
    @learning_plan_goal = assign(:learning_plan_goal, LearningPlanGoal.create!(
      :name => "Name",
      :completed => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
