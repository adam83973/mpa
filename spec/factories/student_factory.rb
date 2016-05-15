FactoryGirl.define do
  factory :student, class: Student do
    first_name "Layla"
    last_name "Sperry"
    xp_total 0
    association :user, factory: :parent
  end
end
