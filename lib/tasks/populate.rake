namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_locations
    make_courses
    make_lessons
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

def make_courses
  Course.create!(course_name:       "Recruits",
                 description:       "KG - 1st Grade")

  Course.create!(course_name:       "Techs",
                 description:       "1st - 2nd Grade")

  Course.create!(course_name:       "Operatives",
                 description:       "2nd - 3rd Grade")

  Course.create!(course_name:       "Analysts",
                 description:       "3rd - 4th Grade")

  Course.create!(course_name:       "Agents",
                 description:       "4th - 5th Grade")

  Course.create!(course_name:       "Special Ops",
                 description:       "5th - 6th Grade")

  Course.create!(course_name:       "Pre-Algebra",
                 description:       "6th - 7th Grade")
end


def make_experiences
  Experience.create!(name:              "Homework",
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")

  Experience.create!(name:              "Attendance",
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")
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