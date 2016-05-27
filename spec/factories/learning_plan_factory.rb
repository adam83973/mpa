FactoryGirl.define do
  factory :learning_plan, class: LearningPlan do
    association :student, factory: :student
    association :user, factory: :admin
    grade "KG"
    association :course, factory: :course, course_name: "Recruit"
    learning_plan_issue_id 1
  end
end
