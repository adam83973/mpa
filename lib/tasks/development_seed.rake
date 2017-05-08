namespace :development do
  desc "Seed development environment"
  task :seed, [:subdomain] => :environment do |task, args|
    seed_common(args)
    seed_development_environment(args)
  end
end

def seed_image(asset_folder, file_name)
  File.open(File.join(Rails.root, "/app/assets/images/#{asset_folder}/#{file_name}"))
end

def seed_lessons(asset_folder, file_name)
  File.open(File.join(Rails.root, "/app/assets/sample_lessons/#{asset_folder}/#{file_name}"))
end

def seed_common(args)
  create_courses
  create_avatars(args)
  create_occupations
  create_occupation_levels(args)
  create_badges(args)
  create_experiences(args)
end



def seed_development_environment(args)
  create_locations
  create_users(args)
  create_offerings
  create_opportunities
  create_notes
  create_registrations
  create_lessons(args)
  create_products
  create_family_for_parent_ui_testing(args)
end

def create_courses
  # Create courses
  course_names_and_descriptions = [
    ['Recruits','KG - 1st Grade'], ['Techs','1st - 2nd Grade'],
    ['Operatives', '2nd - 3rd Grade'], ['Analysts', '3rd - 4th Grade'],
    ['Agents', '4th-5th Grade'], ['Special Ops','5th - 6th Grade'],
    ['Pre-Algebra','6th - 7th Grade'], ['Algebra', '7th - 8th Grade'],
    ['Geometry', '8th - 9th Grade'], ['Chess Club','4th - 8th Grade'],
    ['Problem Solving Lab','7th - 8th Grade'], ['Programming Lab','4th - 8th Grade']]

  course_names_and_descriptions.each_with_index do |course_info, i|
    has_assignments = (i < 9) ? true : false
    Course.create!(name:              course_info[0],
                   description:       course_info[1],
                   grade:             course_info[1].gsub(' Grade', ''),
                   capacity:          10,
                   occupation_id:     1,
                   has_assignments:   has_assignments)
  end
end

def create_avatars(args)
  # Create avatars
  avatar_names = ['Boy', 'Girl', 'Robot']

  avatar_names.each do |name|
    file_name = "MATHPLUS-avatar-#{name.downcase}.png"
    Avatar.create!(name:            name,
                   image:           seed_image('avatars', file_name),
                   company_id:      args[:subdomain])
  end
end

def create_occupations
  # Create occupations
  Occupation.create!(title:             'Mathematician',
                     description:       'Your working to master the ins and
                                        outs of math. Keep up the good work and
                                        and good luck on your journey!')

  Occupation.create!(title:             'Engineer',
                     description:       'So you like making things? This is
                                        a great track for your. Keep your nose
                                        to the grind stone and let\'s see what
                                        you can create!')

  Occupation.create!(title:             'Programmer',
                     description:       'It\'s fun telling people to do things
                                        for you. Why not learn to do the same
                                        with computers? They\'re much faster than
                                        humans.')
end

def create_occupation_levels(args)
  occupations_id_and_name = Occupation.pluck(:id, :title)

  # Add occupation levels. This sets up the leveling system for students
  occupations_id_and_name.each_with_index do |occupation_info, i|
    next if occupation_info[1].downcase == 'badges'
    10.times do |n|
      image_file = "MATHPLUS-#{occupation_info[1].downcase}-L#{"%02d" % (n)}.png"
      OccupationLevel.create!(level:                n,
                              points:               1000 * n+1,
                              rewards:              "Level #{n} Reward",
                              occupation_id:        occupation_info[0],
                              image:                seed_image("math_plus_icons", image_file),
                              company_id:           args[:subdomain])
    end
  end
end

def badge_names
  ['Attention To Detail', 'Dedication', 'Explorer', 'Helping Others', 'Hot Streak', 'Insightful Questions', 'Mathematician', 'Mental Math', 'Mind Bender', 'Number Cruncher', 'Perfection', 'Positive Attitude', 'Problem Solver', 'Scientist', 'Teamwork']
end

def create_badges(args)
  # Create badges - A few basic badges are seeded and their images are added as
  # assets. Additional badges can be added and their images uploaded.

  badge_names.each do |name|
    image_file = "MATHPLUS-Badge-#{name.downcase.gsub(' ', '-')}.png"
    Badge.create!(name:       name,
                  image:      seed_image("badges", image_file),
                  multiple:   true,
                  company_id: args[:subdomain])
  end
end

def create_experiences(args)
  # Create experiences - A few experience points need to be seeded. XP that are associated to seeded badges. XP that are associated to attendance. XP that are associated to assignments. This seed should not include any non-production information.

  # Experiences for badges
  badge_names.each do |badge_name|
    badge = Badge.where(name: badge_name).first

    experience = Experience.create!(name:             "#{badge_name} Badge",
                                    content:          "Please update this with a description the of the badge.",
                                    points:           75,
                                    active:           true,
                                    company_id:       args[:subdomain])
    badge.update_attribute :experience_id, experience.id
  end

  # Experiences for attendance
  Experience.create!(name:            "Attendance - Math Class",
                     content:         "Points for attending a class. Plain and simple.",
                     points:          20,
                     active:          true,
                     attendance:      true)

  Experience.create!(name:            "Attendance - Chess Club",
                     content:         "Points for attending a class. Plain and simple.",
                     points:          20,
                     active:          true,
                     attendance:      true,
                     course_id:       Course.where(name: 'Chess Club').pluck(:id).first)

  Experience.create!(name:            "Attendance - Programming Lab",
                     content:         "Points for attending a class. Plain and simple.",
                     points:          20,
                     active:          true,
                     attendance:      true,
                     course_id:       Course.where(name: 'Programming Lab').pluck(:id).first)

  # Experiences for assignments
  assignment_statuses_and_points = [["Incomplete", 0], ["Complete", 60], ["Perfect", 80]]

  assignment_statuses_and_points.each do |assignment_info|
    Experience.create!(name:            assignment_info[0],
                       content:         "You attended class. That's half the battle!",
                       points:          assignment_info[1],
                       assignment:      true,
                       active:          true)
  end
end

def create_locations
  #create locations
  3.times do
    city = Faker::Address.city
    Location.create!(name: city,
                     address: Faker::Address.street_address,
                     city: city,
                     state: Faker::Address.state,
                     zip: Faker::Address.city)
  end
end

def location_ids
  Location.pluck(:id)
end

def create_users(args)
  # Create admins
  admin = User.create!(first_name: 'Travis',
                       last_name: 'Sperry',
                       email: 'admin@mathplusacademy.dev',
                       password: 'password',
                       password_confirmation: 'password',
                       phone: Faker::PhoneNumber.cell_phone,
                       address: Faker::Address.street_address,
                       city: Faker::Address.city,
                       state: Faker::Address.state,
                       zip: Faker::Address.zip,
                       location_id: Location.first.id,
                       active: true,
                       admin: true,
                       role: 'Admin',
                       subdomain: "#{args[:subdomain]}")
                         # Create admins

  system_admin = User.create!(first_name: 'System',
                              last_name: 'Administrator',
                              email: 'system_admin@mathplusacademy.dev',
                              password: 'qwertyqwerty1',
                              password_confirmation: 'qwertyqwerty1',
                              phone: Faker::PhoneNumber.cell_phone,
                              address: Faker::Address.street_address,
                              city: Faker::Address.city,
                              state: Faker::Address.state,
                              zip: Faker::Address.zip,
                              location_id: Location.first.id,
                              active: true,
                              admin: true,
                              system_administrator: true,
                              role: 'Admin',
                              subdomain: "#{args[:subdomain]}")

  # Create employees (directors, teachers, teaching assistants)

  # Directors
  20.times do
    User.create!(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: Faker::Internet.email,
                 password: 'password',
                 password_confirmation: 'password',
                 phone: Faker::PhoneNumber.cell_phone,
                 address: Faker::Address.street_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state,
                 zip: Faker::Address.zip,
                 location_id: Location.first.id,
                 active: true,
                 admin: true,
                 role: 'Admin',
                 subdomain: "#{args[:subdomain]}")
  end

  # Teachers
  20.times do
    User.create!(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: Faker::Internet.email,
                 password: 'password',
                 password_confirmation: 'password',
                 phone: Faker::PhoneNumber.cell_phone,
                 address: Faker::Address.street_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state,
                 zip: Faker::Address.zip,
                 location_id: location_ids.sample,
                 active: true,
                 role: 'Teacher',
                 subdomain: "#{args[:subdomain]}")
  end

  # Teaching Assistants
  10.times do
    User.create!(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: Faker::Internet.email,
                 password: 'password',
                 password_confirmation: 'password',
                 phone: Faker::PhoneNumber.cell_phone,
                 address: Faker::Address.street_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state,
                 zip: Faker::Address.zip,
                 location_id: location_ids.sample,
                 active: true,
                 role: 'Teaching Assistant',
                 subdomain: "#{args[:subdomain]}")
  end

  # Create parents
  300.times do
    User.create!(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: Faker::Internet.email,
                 password: 'password',
                 password_confirmation: 'password',
                 phone: Faker::PhoneNumber.cell_phone,
                 address: Faker::Address.street_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state,
                 zip: Faker::Address.zip,
                 location_id: location_ids.sample,
                 active: true,
                 role: 'Parent',
                 subdomain: "#{args[:subdomain]}")
  end

  parents = User.where(role: 'Parent')

  # Create students with parent associations
  avatar_ids = Avatar.pluck(:id)
  occupation_ids = Occupation.pluck(:id)

  parents.each do |parent|
    hex_value = (0..2).map{"%0x" % (rand * 0x80 + 0x80)}.join.upcase # color for avatar bg
    student = Student.create!(first_name:                          Faker::Name.first_name,
                             last_name:                           parent.last_name,
                             user_id:                             parent.id,
                             avatar_id:                           avatar_ids.sample,
                             avatar_background_color:             "##{hex_value}",
                             mathematician_experience_points:     [0, 100, 300, 500, 1500, 2000].sample,
                             engineer_experience_points:          [0, 100, 300, 500, 1500, 2000].sample,
                             programmer_experience_points:        [0, 100, 300, 500, 1500, 2000].sample,
                             current_occupation_id:               occupation_ids.sample,
                             xp_total:                            0)
    student.update_attributes experience_point_total:             student.sum_occupation_experience_points,
                              credits:                            student.sum_occupation_experience_points/100

    if [0, 1].sample % 2 == 1
      hex_value = (0..2).map{"%0x" % (rand * 0x80 + 0x80)}.join.upcase # color for avatar bg
      student = Student.create!(first_name:                          Faker::Name.first_name,
                               last_name:                           parent.last_name,
                               user_id:                             parent.id,
                               avatar_id:                           avatar_ids.sample,
                               avatar_background_color:             "##{hex_value}",
                               mathematician_experience_points:     [0, 100, 300, 500, 1500, 2000].sample,
                               engineer_experience_points:          [0, 100, 300, 500, 1500, 2000].sample,
                               programmer_experience_points:        [0, 100, 300, 500, 1500, 2000].sample,
                               current_occupation_id:               occupation_ids.sample,
                               xp_total:                            0)
      student.update_attributes experience_point_total:             student.sum_occupation_experience_points,
                                credits:                            student.sum_occupation_experience_points/100
    end
  end
end

def create_offerings
  # Create offerings (with teacher associations) for each location
  120.times do
    teacher = User.where(role: "Teacher").order("RANDOM()").first
    teaching_assistant = User.where(role: "Teaching Assistant").order("RANDOM()").first
    course = Course.order("RANDOM()").first
    location = Location.order("RANDOM()").first
    day_number = rand(1..6)
    time = day_number != 6 ? Time.utc(2000,"jan",1,rand(16..19),30, 0) : Time.utc(2000,"jan",1,rand(9..14),30, 0)

    offering = Offering.create!(course_id:             course.id,
                                location_id:           location.id,
                                day:                   Date::DAYNAMES[day_number],
                                day_number:            day_number,
                                active:                true,
                                classroom:             %w(A B C).sample,
                                time:                  time)

    OfferingsUser.create!(offering_id: offering.id, user_id: teacher.id)
    OfferingsUser.create!(offering_id: offering.id, user_id: teaching_assistant.id)
  end
end

def create_opportunities
  director_ids = User.pluck(:id)
  parents = User.where(role: 'Parent')
  offerings = Offering.all

  #create random trials
  15.times do
    parent = parents.sample
    student = parent.students.sample

    offering = offerings.sample

    Opportunity.create!(status:                 3,
                        location_id:            offering.location_id,
                        admin_id:               director_ids.sample,
                        user_id:                parent.id,
                        student_id:             student.id,
                        course_id:              offering.course_id,
                        offering_id:            offering.id,
                        trial_date:             Date.today + [0, 1, 5, 10].sample.days,
                        attended_trial:         false,
                        date_won:               nil,
                        date_lost:              nil)
  end
end

def create_notes
  director_ids = User.where(role: 'Admin').pluck(:id)
  parent_id_and_last_name = User.where(role: 'Parent').pluck(:id, :last_name)

  # Create notes for parents
  30.times do
    Note.create!(user_id:           director_ids.sample,
                 content:           Faker::Lorem.sentence(3, false, 6),
                 notable_id:        parent_id_and_last_name.sample[0],
                 notable_type:      "User")
  end

  # Create needs action notes that are due for parents for each location
  30.times do
    note = Note.create!(user_id:           director_ids.sample,
                        content:           Faker::Lorem.sentence(3, false, 6),
                        notable_id:        parent_id_and_last_name.sample[0],
                        notable_type:      "User",
                        action_date:       Date.today - 1.day,
                        location_id:       rand(1..3))

    note.update_attribute :created_at, Date.today - rand(0..5).days
  end

  # Create needs action notes that are not due for parents for each location
  10.times do
    Note.create!(user_id:           director_ids.sample,
                 content:           Faker::Lorem.sentence(3, false, 6),
                 notable_id:        parent_id_and_last_name.sample[0],
                 notable_type:      "User",
                 action_date:       Date.today + rand(5..20).days,
                 location_id:       rand(1..3))
  end

  # Create needs action notes that are not due for parents for each location
  15.times do |n|
    director_id = director_ids.sample
    note = Note.create!(user_id:           director_id,
                        content:           Faker::Lorem.sentence(3, false, 6),
                        notable_id:        parent_id_and_last_name.sample[0],
                        notable_type:      "User",
                        action_date:       Date.today + rand(20..60).days,
                        location_id:       rand(1..3))
  end
end

def create_registrations
  director_ids = User.where(role: 'Admin').pluck(:id)
  student_ids = Student.pluck(:id)
  offering_ids = Offering.pluck(:id)

  # Create registrations
  450.times do
    Registration.create!(start_date:              Date.today - rand(15..900).days,
                        end_date:                 nil,
                        hold_date:                nil,
                        trial_date:               nil,
                        attended_first_class:     true,
                        attended_trial:           false,
                        student_id:               student_ids.sample,
                        offering_id:              offering_ids.sample,
                        admin_id:                 director_ids.sample,
                        status:                   1)
  end

  # Create registrations that are going to be added
  10.times do
    Registration.create!(start_date:              Date.today + rand(1..30).days,
                        end_date:                 nil,
                        hold_date:                nil,
                        trial_date:               nil,
                        attended_first_class:     false,
                        attended_trial:           false,
                        student_id:               student_ids.sample,
                        offering_id:              offering_ids.sample,
                        admin_id:                 director_ids.sample,
                        status:                   0)
  end

  # Create registrations that are going to go on hold
  15.times do
    rand_future_date = Date.today + rand(10..45).days
    student_id = student_ids.sample
    offering_id = offering_ids.sample

    registration_1 = Registration.create!(start_date:              Date.today - rand(60..900).days,
                                         end_date:                 nil,
                                         hold_date:                rand_future_date,
                                         restart_date:             nil,
                                         hold_id:                  nil,
                                         switch_id:                nil,
                                         switch:                   false,
                                         trial_date:               nil,
                                         attended_first_class:     true,
                                         attended_trial:           false,
                                         student_id:               student_id,
                                         offering_id:              offering_id,
                                         admin_id:                 director_ids.sample,
                                         status:                   1)

    registration_2 = Registration.create!(start_date:               nil,
                                          end_date:                 nil,
                                          hold_date:                nil,
                                          restart_date:             rand_future_date + rand(20..90).days,
                                          hold_id:                  registration_1.id,
                                          switch_id:                nil,
                                          switch:                   false,
                                          trial_date:               nil,
                                          attended_first_class:     true,
                                          attended_trial:           false,
                                          student_id:               student_id,
                                          offering_id:              offering_id,
                                          admin_id:                 director_ids.sample,
                                          status:                   2)
  end

  # Create registrations that are already on hold, but haven't restarted
  15.times do
    rand_past_date = Date.today - rand(10..45).days
    rand_future_date = Date.today + rand(10..45).days
    student_id = student_ids.sample
    offering_id = offering_ids.sample

    registration_1 = Registration.create!(start_date:               Date.today - rand(60..900).days,
                                          end_date:                 nil,
                                          hold_date:                rand_past_date,
                                          restart_date:             nil,
                                          hold_id:                  nil,
                                          switch_id:                nil,
                                          switch:                   false,
                                          trial_date:               nil,
                                          attended_first_class:     true,
                                          attended_trial:           false,
                                          student_id:               student_id,
                                          offering_id:              offering_id,
                                          admin_id:                 director_ids.sample,
                                          status:                   3)

    registration_2 = Registration.create!(start_date:               nil,
                                          end_date:                 nil,
                                          hold_date:                nil,
                                          restart_date:             rand_future_date,
                                          hold_id:                  registration_1.id,
                                          switch_id:                nil,
                                          switch:                   false,
                                          trial_date:               nil,
                                          attended_first_class:     true,
                                          attended_trial:           false,
                                          student_id:               student_id,
                                          offering_id:              offering_id,
                                          admin_id:                 director_ids.sample,
                                          status:                   2)
  end


  # Create registrations that are switches
  5.times do
    rand_future_date = Date.today + rand(5..10).days
    student_id = student_ids.sample
    offering_id = offering_ids.sample

    registration_1 = Registration.create!(start_date:               Date.today - rand(60..900).days,
                                          end_date:                 rand_future_date,
                                          hold_date:                nil,
                                          restart_date:             nil,
                                          hold_id:                  nil,
                                          switch_id:                nil,
                                          switch:                   false,
                                          trial_date:               nil,
                                          attended_first_class:     true,
                                          attended_trial:           false,
                                          student_id:               student_id,
                                          offering_id:              offering_id,
                                          admin_id:                 director_ids.sample,
                                          status:                   1)

    registration_2 = Registration.create!(start_date:               rand_future_date,
                                          end_date:                 nil,
                                          hold_date:                nil,
                                          restart_date:             nil,
                                          hold_id:                  registration_1.id,
                                          switch_id:                nil,
                                          switch:                   true,
                                          trial_date:               nil,
                                          attended_first_class:     true,
                                          attended_trial:           false,
                                          student_id:               student_id,
                                          offering_id:              offering_id,
                                          admin_id:                 director_ids.sample,
                                          status:                   0)

    registration_1.update_attribute(:switch_id, registration_2.id)
  end
end

def create_lessons(args)
  # Create lessons that are associated to each course. Only seeding and uploading
  # lessons for one class.

  48.times do |n|
    resource = Resource.create!(file:               seed_lessons("recruits", "recruit#{n+1}.pdf"),
                                category:           0,
                                company_id:         args[:subdomain])

    lesson = Lesson.create!(name:             "Lesson #{n+1}",
                            week:             n+1,
                            assignment:       resource.id.to_s,
                            assignment_key:   nil,
                            course_id:        1)
  end
end

def create_products
  products = ['Settlers of Catan', 'Swish', 'Set', 'Rush Hour', 'Tipover', 'Sleeping Queens']
  virtual_products = ['iTunes Gift Card', 'Amazon Gift Card']
  3.times do |n|
    products.each do |product|
      Product.create!(name:                     product,
                      price:                    [1499, 1899, 2599].sample,
                      credits:                  [15, 20, 25].sample,
                      location_id:              n,
                      quantity:                 rand(6..15))
    end
  end

  3.times do |n|
    virtual_products.each do |product|
      Product.create!(name:                     product,
                      price:                    1000,
                      credits:                  25,
                      location_id:              n,
                      quantity:                 0,
                      virtual:                  true)
    end
  end
end

def create_family_for_parent_ui_testing(args)
  # Add parent
  parent = User.create!(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         email: 'parent@mathplusacademy.dev',
                         password: 'password',
                         password_confirmation: 'password',
                         phone: Faker::PhoneNumber.cell_phone,
                         address: Faker::Address.street_address,
                         city: Faker::Address.city,
                         state: Faker::Address.state,
                         zip: Faker::Address.zip,
                         location_id: location_ids.sample,
                         active: true,
                         role: 'Parent',
                         subdomain: "#{args[:subdomain]}")

  # Add kids and associated registrations
  3.times do
    hex_value = (0..2).map{"%0x" % (rand * 0x80 + 0x80)}.join.upcase # color for avatar bg
    director_id = User.where(role: 'Admin').pluck(:id).sample
    offering_id = Offering.pluck(:id).sample
    avatar_id = Avatar.pluck(:id).sample
    occupation_id = Occupation.pluck(:id).sample

    student = Student.create!(first_name:                          Faker::Name.first_name,
                              last_name:                           parent.last_name,
                              user_id:                             parent.id,
                              avatar_id:                           avatar_id,
                              avatar_background_color:             "##{hex_value}",
                              mathematician_experience_points:     [0, 100, 300, 500, 1500, 2000].sample,
                              engineer_experience_points:          [0, 100, 300, 500, 1500, 2000].sample,
                              programmer_experience_points:        [0, 100, 300, 500, 1500, 2000].sample,
                              current_occupation_id:               occupation_id,
                              xp_total:                            0)
    student.update_attributes experience_point_total:             student.sum_occupation_experience_points,
                             credits:                    student.sum_occupation_experience_points/100

    Registration.create!(start_date:               Date.today - rand(15..900).days,
                         end_date:                 nil,
                         hold_date:                nil,
                         trial_date:               nil,
                         attended_first_class:     true,
                         attended_trial:           false,
                         student_id:               student.id,
                         offering_id:              offering_id,
                         admin_id:                 director_id,
                         status:                   1)

    15.times do |n|
       Assignment.create!(student_id:             student.id,
                          score:                  rand(0..2),
                          user_id:                director_id,
                          week:                   n+1,
                          offering_id:            offering_id,
                          course_id:              Offering.find(offering_id).course_id,
                          comment:                'Amazing work on this assignment! You did fantastic!')
    end
  end
end
