FactoryGirl.define do
  factory :parent, class: User do
    first_name "John"
    last_name  "Doe"
    role "Parent"
    email "test@mtest.com"
    password "password"
    association :location, factory: :location, name: "Powell"
  end
  factory :teacher, class: User do
    first_name "Jane"
    last_name  "Teacher"
    role "Teacher"
    email "test@mtest.com"
    password "password"
    association :location, factory: :location, name: "Powell"
  end
  factory :admin, class: User do
    first_name "Raj"
    last_name  "Owner"
    role "Admin"
    email "admin@mtest.com"
    password "password"
    association :location, factory: :location, name: "Powell"
  end
end
