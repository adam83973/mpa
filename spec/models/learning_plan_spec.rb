require 'rails_helper'

RSpec.describe LearningPlan, type: :model do
  let(:learning_plan){FactoryGirl.create(:learning_plan)}
  let(:student){FactoryGirl.create(:student)}
  let(:student_2){FactoryGirl.create(:student_2)}
  let(:goal_1){FactoryGirl.create(:goal_1)}
  let(:goal_2){FactoryGirl.create(:goal_2)}
  let(:goal_3){FactoryGirl.create(:goal_3)}

  it "counts the number of goals" do
    expect(learning_plan.goals.count).to eq(3)
  end

  it "changes has learning plan flag on student account" do
    expect expect(student.has_learning_plan).to eq(true)
  end

end
