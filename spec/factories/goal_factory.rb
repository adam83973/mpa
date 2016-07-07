FactoryGirl.define do
  factory :goal_1, class: LearningPlanGoal do
    name "Goal 1 is great."
    association :learning_plan, factory: :learning_plan
  end
  factory :goal_2, class: LearningPlanGoal do
    name "Goal 1 is great."
    association :learning_plan, factory: :learning_plan
  end
  factory :goal_3, class: LearningPlanGoal do
    name "Goal 1 is great."
    association :learning_plan, factory: :learning_plan
  end
end
