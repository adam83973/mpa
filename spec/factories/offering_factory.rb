FactoryGirl.define do
  factory :offering, class: Offering do
    association :course, factory: :course
    association :location, factory: :location
    time Time.parse('16:30:00')
    day "Wednesday"
    day_number 3
    classroom "B"
    active true
  end
end
