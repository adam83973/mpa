# Create companies

# Create locations
locations = ['Powell', 'Hilliard', 'New Albany']

locations.each do |location|
  Location.create!(name: location,
                   address: Faker::Address.street_address,
                   city: Faker::Address.city,
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
450.times do
  parent_info = parent_id_and_last_name.sample #array of parent ids and last names
  Student.create!(first_name:           Faker::Name.first_name,
                  last_name:            parent_info[1],
                  user_id:              parent_info[0],
                  xp_total:             0,
                  credits:              1)
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
                      action_date:       Date.today - 1.day)

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

# Create lessons that are associated to each course

# Create assignments that are associated to students

# Create experience points that are associated to experiences, badges, attendances,
# and assignments.
