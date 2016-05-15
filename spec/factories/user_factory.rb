FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  factory :parent, class: User do
    first_name "Travis"
    last_name  "Parent"
    role "Parent"
    email
    password "password"
    password_confirmation "password"
    association :location, factory: :location, name: "Powell"
  end
  factory :teacher, class: User do
    first_name "Jane"
    last_name  "Teacher"
    role "Teacher"
    email
    password "password"
    password_confirmation "password"
    association :location, factory: :location, name: "Powell"
  end
  factory :admin, class: User do
    first_name "Raj"
    last_name  "Admin"
    role "Admin"
    email
    password "password"
    password_confirmation "password"
    association :location, factory: :location, name: "Powell"
  end
end
