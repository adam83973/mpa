namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_locations
    make_students
    make_offerings
    make_courses
    make_lessons
    make_offerings_students
    make_experience_points
    make_experiences
  end
end

def make_users
  admin = User.create!(first_name:            "Travis",
                       last_name:             "Kendall",
                       role:                  "Admin",
                       phone:                 "(614) 260-6162",
                       location_id:           "2",              
                       email:                 "tkendalls@aol.com",
                       password:              "password",
                       password_confirmation: "password")
  admin.toggle!(:admin)

  admin1 = User.create!(first_name:           "Raj",
                        last_name:            "Shah",
                        role:                 "Admin",
                        phone:                 "(614) 787-4741",
                        location_id:          "1",              
                        email:                "raj@mathplusacademy.com",
                        password:             "password",
                        password_confirmation:"password")

  admin1.toggle!(:admin)
  
  10.times do |n|
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    role = "Teacher"
    email = "example-#{n+1}@mathplusacademy.com"
    password  = "password"
    password_confirmation  = "password"
    phone = Faker::PhoneNumber.phone_number
    passion = Faker::Lorem.sentence
    address = Faker::Address.street_address
    location_id = "#{(3+(-1)**n)/2}"

    User.create!(first_name:              first_name,
                 last_name:               last_name,
                 role:                    role,
                 email:                   email,
                 password:                password,
                 password_confirmation:   password_confirmation,
                 phone:                   phone,
                 passion:                 passion,
                 address:                 address,
                 location_id:             location_id)
  end
  10.times do |n|
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    role = "Parent"
    email = "example-#{n+11}@mathplusacademy.com"
    password  = "password"
    password_confirmation  = "password"
    phone = Faker::PhoneNumber.phone_number
    passion = Faker::Lorem.sentence
    address = Faker::Address.street_address
    location_id = "#{(3+(-1)**n)/2}"

    User.create!(first_name:              first_name,
                 last_name:               last_name,
                 role:                    role,
                 email:                   email,
                 password:                password,
                 password_confirmation:   password_confirmation,
                 phone:                   phone,
                 passion:                 passion,
                 address:                 address,
                 location_id:             location_id)
  end
  77.times do |n|
    first_name  = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    roll = "#{["Owner", "Director", "Teacher", "Teaching Assistant", "Parent"].sample}"
    email = "example-#{n+21}@mathplusacademy.com"
    password  = "password"
    password_confirmation  = "password"
    phone = Faker::PhoneNumber.phone_number
    passion = Faker::Lorem.sentence
    address = Faker::Address.street_address
    location_id = "#{(3+(-1)**n)/2}"

    User.create!(first_name:              first_name,
                 last_name:               last_name,                 
                 role:                    roll,
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
 10.times do |n|
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    birth_date = "12/12/2004"
    start_date = "12/12/2010"
    user_id    = "#{n+13}"

    Student.create!(first_name:              first_name,
                    last_name:               last_name,
                    birth_date:              birth_date,
                    start_date:              start_date,
                    user_id:                 user_id)
  end
end

def make_offerings_students
 20.times do |n|
    offering_id = "#{(n+1)%4}"
    student_id  = "#{Math.sqrt(n+n).round}"

    OfferingsStudent.create!(offering_id:              offering_id,
                              student_id:              student_id)
  end
end

def make_offerings
  Offering.create!(course_id:         "1",
                   location_id:       "2",
                   day:               "Monday",
                   time:              "4:30 PM",
                   user_id:           "3")

  Offering.create!(course_id:         "2",
                   location_id:       "2",
                   day:               "Monday",
                   time:              "5:30 PM",
                   user_id:           "3")

  Offering.create!(course_id:         "3",
                   location_id:       "1",
                   day:               "Tuesday",
                   time:              "4:30 PM",
                   user_id:           "3")

  Offering.create!(course_id:         "4",
                   location_id:       "1",
                   day:               "Thursday",
                   time:              "5:30 PM",
                   user_id:           "3")
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


def make_experiences
  Experience.create!(name:              "Homework",
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")

  Experience.create!(name:              "Attendance",
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")
end

def make_experience_points
  10.times do |t|
    10.times do |n|
      experience_id  = "#{(3+(-1)**n)/2}"
      points = "#{["5", "10"].sample}"
      student_id = "#{t+1}"

      ExperiencePoint.create!(experience_id:    experience_id,
                              points:           points,
                              student_id:       student_id)
    end
  end
end

def make_lessons
  48.times do |n|
    name = "Lesson- #{n+1}"
    week = "#{n+1}"
    course_id  = "1"
    assignment  = "https://www.dropbox.com/s/nagajhz3zq909bj/Recruit%201%20-%20Read%20Write%20Digits%200-9.pdf"
    assignment_key  = "https://www.dropbox.com/s/076q0byftiqkvih/Recruit%201%20-%20Read%20Write%20Digits%200-9%20KEY.pdf"
    assessment = "#"
    assessment_key = "#"

    Lesson.create!(name:                 name,
                   week:                  week,
                   course_id:             course_id,
                   assignment:            assignment,
                   assignment_key:        assignment_key,
                   assessment:            assessment,
                   assessment_key:        assessment_key)
  end
end

# def make_relationships
#   users = User.all
#   user  = users.first
#   followed_users = users[2..50]
#   followers      = users[3..40]
#   followed_users.each { |followed| user.follow!(followed) }
#   followers.each      { |follower| follower.follow!(user) }
# end