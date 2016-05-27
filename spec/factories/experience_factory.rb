FactoryGirl.define do
  factory :attendance_experience, class: Experience do
    id       1
    name     "Attendance"
    category "In-Class"
    points   20
    active   true
  end
end
