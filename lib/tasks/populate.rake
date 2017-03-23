namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_locations
    # make_courses
    # make_lessons
    # make_experiences
  end
end

def make_users
  admin = User.create!(first_name:            "Travis",
                       last_name:             "Sperry",
                       role:                  "Admin",
                       phone:                 "(614) 260-6162",
                       location_id:           "2",
                       email:                 "director@mathplusacademy.com",
                       password:              "password",
                       password_confirmation: "password")
  admin.toggle!(:admin)
  admin.toggle!(:active)

  admin1 = User.create!(first_name:           "Raj",
                        last_name:            "Shah",
                        role:                 "Admin",
                        phone:                "(614) 787-4741",
                        location_id:          "1",
                        email:                "raj@mathplusacademy.com",
                        password:             "password",
                        password_confirmation:"password")

  admin1.toggle!(:admin)
  admin1.toggle!(:active)

  admin2 = User.create!(first_name:           "Madison",
                        last_name:            "Corna",
                        role:                 "Admin",
                        phone:                 "(614) 7946-9986",
                        location_id:          "1",
                        email:                "madison@mathplusacademy.com",
                        password:             "password",
                        password_confirmation:"password")

  admin2.toggle!(:admin)

  User.create!(first_name:                    "Brittney",
                        last_name:            "Green",
                        role:                 "Teacher",
                        phone:                "(740) 412-3894",
                        location_id:          "1",
                        email:                "brittgreen88@gmail.com",
                        password:             "password",
                        password_confirmation:"password")

  User.create!(first_name:                    "Olivia",
                        last_name:            "Dowell",
                        role:                 "Teaching Assistant",
                        phone:                "(614) 783-0920",
                        location_id:          "1",
                        email:                "tdowell817@aol.com",
                        password:             "password",
                        password_confirmation:"password")

  User.create!(first_name:                    "Betsy",
                        last_name:            "Rafferty",
                        role:                 "Teacher",
                        phone:                "614-209-7835",
                        location_id:          "1",
                        email:                "eraffer1@gmail.com",
                        password:             "password",
                        password_confirmation:"password")

  User.create!(first_name:           "Ved",
               last_name:            "Shelat",
               role:                 "Teaching Assistant",
               phone:                "614-425-2986",
               location_id:          "1",
               email:                "veds99@yahoo.com",
               password:             "password",
               password_confirmation:"password")

User.create!(first_name:           "John",
             last_name:            "Doe",
             role:                 "Parent",
             phone:                "(614) 555-1212",
             location_id:          "1",
             email:                "parent@mathplusacademy.com",
             password:             "password",
             password_confirmation:"password")

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
  Course.create!(name:              "Recruits",
                 description:       "KG - 1st Grade")

  Course.create!(name:              "Techs",
                 description:       "1st - 2nd Grade")

  Course.create!(name:              "Operatives",
                 description:       "2nd - 3rd Grade")

  Course.create!(name:              "Analysts",
                 description:       "3rd - 4th Grade")

  Course.create!(name:              "Agents",
                 description:       "4th - 5th Grade")

  Course.create!(name:               "Special Ops",
                 description:       "5th - 6th Grade")

  Course.create!(name:               "Pre-Algebra",
                 description:       "6th - 7th Grade")
end


def make_experiences
  Experience.create!(name:              "Homework",
                     points:            20,
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")

  Experience.create!(name:              "Attendance",
                     points:            20,
                     category:          "Tasks",
                     content:           "This is the everyday stuff anybody can do this.")
end

def make_lessons
  48.times do |n|
    name = "Lesson- #{n+1}"
    week = "#{n+1}"
    course_id  = "1"

    Lesson.create!(name:                 name,
                   week:                  week,
                   course_id:             course_id)
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
