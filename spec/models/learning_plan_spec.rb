require 'rails_helper'

RSpec.describe LearningPlan, type: :model do
  let(:learning_plan){FactoryGirl.create(:learning_plan)}
  let(:student){FactoryGirl.create(:student)}

  it "counts the number of goals" do
    expect(learning_plan.goals.count).to eq(3)
  end

  it "changes has learning plan flag on student account" do
    expect {
      FactoryGirl.create(:learning_plan)
    }.to change(student, :has_learning_plan).to(true)
  end

end
