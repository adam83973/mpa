FactoryGirl.define do
  factory :attendance, class: Attendance do
    association :student, factory: :student, id: 1
    association :offering, factory: :offering
    date Date.today
  end
  factory :attendance1, class: Attendance do
    association :student, factory: :student, id: 2
    association :offering, factory: :offering
    date Date.today
  end
  factory :attendance2, class: Attendance do
    association :student, factory: :student, id: 3
    association :offering, factory: :offering
    date Date.today
  end
end
