namespace :development do
  desc "Seed development environment"
  task seed: :environment do
    seed_common
    seed_development_environment
  end
end

def seed_image(asset_folder, file_name)
  File.open(File.join(Rails.root, "/app/assets/images/#{asset_folder}/#{file_name}"))
end

def seed_lessons(asset_folder, file_name)
  File.open(File.join(Rails.root, "/app/assets/sample_lessons/#{asset_folder}/#{file_name}"))
end

def seed_common
  # Create courses
  course_names_and_descriptions = [
    ['Recruits','KG - 1st Grade'], ['Techs','1st - 2nd Grade'],
    ['Operatives', '2nd - 3rd Grade'], ['Analysts', '3rd - 4th Grade'],
    ['Agents', '4th-5th Grade'], ['Special Ops','5th - 6th Grade'],
    ['Pre-Algebra','6th - 7th Grade'], ['Algebra', '7th - 8th Grade'],
    ['Geometry', '8th - 9th Grade'], ['Chess Club','4th - 8th Grade'],
    ['Problem Solving Lab','7th - 8th Grade'], ['Programming Lab','4th - 8th Grade']]

  course_names_and_descriptions.each do |course_info|
    Course.create!(name:              course_info[0],
                   description:       course_info[1],
                   grade:             course_info[1].gsub(' Grade', ''),
                   capacity:          10,
                   occupation_id:     1)
  end

  # Create avatars
  avatar_names = ['Boy', 'Girl', 'Robot']

  avatar_names.each do |name|
    file_name = "MATHPLUS-avatar-#{name.downcase}.png"
    Avatar.create!(name:           name,
                   image:          seed_image('avatars', file_name))
  end

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
                              image:                seed_image("math_plus_icons", image_file))
    end
  end

  # Create badges - A few basic badges are seeded and their images are added as
  # assets. Additional badges can be added and their images uploaded.

  badge_names = ['Attention To Detail', 'Dedication', 'Explorer', 'Helping Others', 'Hot Streak', 'Insightful Questions', 'Mathematician', 'Mental Math', 'Mind Bender', 'Number Cruncher', 'Perfection', 'Positive Attitude', 'Problem Solver', 'Scientist', 'Teamwork']

  badge_names.each do |name|
    image_file = "MATHPLUS-Badge-#{name.downcase.gsub(' ', '-')}.png"
    Badge.create!(name:     name,
                  image:    seed_image("badges", image_file),
                  multiple: true)
  end


  # Create experiences - A few experience points need to be seeded. XP that are associated to seeded badges. XP that are associated to attendance. XP that are associated to assignments. This seed should not include any non-production information.

  # Experiences for badges
  badge_names.each do |badge_name|
    badge = Badge.where(name: badge_name).first

    experience = Experience.create!(name:            "#{badge_name} Badge",
                                    content:         "Please update this with a description the of the badge.",
                                    points:          75,
                                    active:          true)
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

def seed_development_environment
  #create locations
  3.times do
    city = Faker::Address.city
    Location.create!(name: city,
                     address: Faker::Address.street_address,
                     city: city,
                     state: Faker::Address.state,
                     zip: Faker::Address.city)
  end

  location_ids = Location.all.pluck(:id)
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
                       role: 'Admin')

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
                 role: 'Admin')
  end
  director_ids = User.where(role: 'Admin').pluck(:id)

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
                 role: 'Teacher')
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
                 role: 'Teaching Assistant')
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
                 role: 'Parent')
  end

  parent_id_and_last_name = User.where(role: 'Parent').pluck(:id, :last_name)

  # Create students with parent associations
  avatar_ids = Avatar.pluck(:id)
  occupation_ids = Occupation.pluck(:id)

  450.times do
    parent_info = parent_id_and_last_name.sample #array of parent ids and last names
    hex_value = (0..2).map{"%0x" % (rand * 0x80 + 0x80)}.join.upcase # color for avatar bg
    Student.create!(first_name:                          Faker::Name.first_name,
                    last_name:                           parent_info[1],
                    user_id:                             parent_info[0],
                    avatar_id:                           avatar_ids.sample,
                    avatar_background_color:             "##{hex_value}",
                    mathematician_experience_points:     [0, 100, 300, 500].sample,
                    engineer_experience_points:          [0, 100, 300, 500].sample,
                    programmer_experience_points:        [0, 100, 300, 500].sample,
                    current_occupation_id:               occupation_ids.sample,
                    xp_total:                            0,
                    credits:                             1)
  end

  student_ids = Student.pluck(:id)

  # Create offerings (with teacher associations) for each location
  120.times do
    teacher = User.where(role: "Teacher").order("RANDOM()").first
    course = Course.order("RANDOM()").first
    location = Location.order("RANDOM()").first
    day_number = rand(1..6)
    time = day_number != 6 ? Time.utc(2000,"jan",1,rand(16..19),30, 0) : Time.utc(2000,"jan",1,rand(9..14),30, 0)

    offering = Offering.create!(course_id:             course.id,
                                location_id:           location.id,
                                day:                   Date::DAYNAMES[day_number],
                                day_number:            day_number,
                                active:                true,
                                classroom:             rand(1..3),
                                time:                  time)

    OfferingsUser.create!(offering_id: offering.id, user_id: teacher.id)
  end

  offering_ids = Offering.pluck(:id)

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

  # Create lessons that are associated to each course. Only seeding and uploading
  # lessons for one class.

  48.times do |n|
    resource = Resource.create!(file:              seed_lessons("recruits", "recruit#{n+1}.pdf"),
                                category:          0)

    lesson = Lesson.create!(name:             "Lesson #{n+1}",
                            week:             n+1,
                            assignment:       resource.id.to_s,
                            assignment_key:   nil,
                            course_id:        1)
  end
end
