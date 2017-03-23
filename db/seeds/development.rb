# Create companies

# Create locations
locations = ['Powell', 'Hilliard', 'New Albany']

locations.each do |location|
  Location.create!(name: location,
                   address: Faker::Address.street_address,
                   city: Faker::Address.city,
                   state: Faker::Address.state
                   zip: Faker::Address.city)
end

location_ids = Location.all.pluck(:id)
# Create admins

admin = User.create!(first_name: 'Travis',
                     last_name: 'Sperry',
                     email: 'admin@mathplusacademy.dev'
                     password: 'password',
                     password_confirmation: 'password',
                     phone: Faker::PhoneNumber.cell_phone,
                     address: Faker::Address.street_address,
                     city: Faker::Address.city,
                     state: Faker::Address.state,
                     zip: Faker::Address.zip,
                     location_id: Location.first.id,
                     active: true,
                     admin: true)

# Create employees (directors, teachers, teaching assistants)

# Directors
3.times do
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
2.times do
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
50.times do
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
50.times do
  parent_info = parent_id_and_last_name.sample #array of parent ids and last names
  Student.create!(first_name: Faker::Name.first_name,
                  last_name: parent_info[1],
                  user_id: parent_info[0])
end

# Create offerings (with teacher associations) for each location

# Create notes for parents

# Create lessons that are associated to each course

# Create assignments that are associated to students

# Create experience points that are associated to experiences, badges, attendances,
# and assignments.
