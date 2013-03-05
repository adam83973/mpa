namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_locations
    make_students
    make_offerings
    make_courses
  end
end

def make_users
  admin = User.create!(first_name:            "Travis",
                       last_name:             "Kendall",
                       roll:                  "Director",
                       phone:                 "(614) 260-6162",
                       location_id:           "2",              
                       email:                 "tkendalls@aol.com",
                       password:              "password",
                       password_confirmation: "password")
  admin.toggle!(:admin)
  99.times do |n|
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    email = "example-#{n+1}@mathplusacademy.com"
    password  = "password"
    password_confirmation  = "password"
    phone = Faker::PhoneNumber.phone_number
    passion = Faker::Lorem.sentence
    address = Faker::Address.street_address
    location_id = "#{(3+(-1)**n)/2}"

    User.create!(first_name:              first_name,
                 last_name:               last_name,
                 email:                   email,
                 password:                password,
                 password_confirmation:   password_confirmation,
                 phone:                   phone,
                 passion:                 passion,
                 address:                 address,
                 location_id:             location_id)
  end
end

def make_locations
  Location.create!(name:          "Powell",
                   address:       "9681 Sawmill Road",
                   city:          "Powell",
                   state:         "Ohio",
                   zip:           "43065",)

  Location.create!(name:          "New Albany",
                   address:       "5346 North Hamilton Road",
                   city:          "Columbus",
                   state:         "Ohio",
                   zip:           "43230",)  
end

def make_students
 99.times do |n|
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    birth_date = "12/12/2004"
    start_date = "12/12/2010"
    user_id    = "#{rand(10..30)}"
    offering_id  = "#{rand(1..4)}"

    Student.create!(first_name:              first_name,
                    last_name:               last_name,
                    birth_date:              birth_date,
                    start_date:              start_date,
                    user_id:                 user_id,
                    offering_id:             offering_id)
  end
end

def make_offerings
  Offering.create!(course_id:         "1",
                   location_id:       "2",
                   day:               "Monday",
                   time:              "4:30 PM",
                   user_id:           "#{rand(1..10)}")

  Offering.create!(course_id:         "2",
                   location_id:       "2",
                   day:               "Monday",
                   time:              "5:30 PM",
                   user_id:           "#{rand(1..10)}")

  Offering.create!(course_id:         "3",
                   location_id:       "1",
                   day:               "Tuesday",
                   time:              "4:30 PM",
                   user_id:           "#{rand(1..10)}")

  Offering.create!(course_id:         "4",
                   location_id:       "1",
                   day:               "Thursday",
                   time:              "5:30 PM",
                   user_id:           "#{rand(1..10)}")
end

def make_courses
  Course.create!(course_name:       "Recruits",
                 description:       "Super class")

  Course.create!(course_name:       "Techs",
                 description:       "Awesome class")

  Course.create!(course_name:       "Operatives",
                 description:       "Radical class")

  Course.create!(course_name:       "Analysts",
                 description:       "Bodacious class")
end

# def make_relationships
#   users = User.all
#   user  = users.first
#   followed_users = users[2..50]
#   followers      = users[3..40]
#   followed_users.each { |followed| user.follow!(followed) }
#   followers.each      { |follower| follower.follow!(user) }
# end