namespace :application do
  desc "Seed application defaults after company is created."
  task :seed, [:subdomain] => :environment do |task, args|
    seed_application(args)
  end
end

def seed_application(args)
  create_locations
  create_users(args)
  create_math_courses
  create_avatars
  create_occupations
  create_occupation_levels
  create_badges
  create_experiences
  puts 'Application seeding complete.'
end

def create_locations
  puts 'Building locations.'
  #create default location
  Location.create!(name: 'Please update location name',
                   address: 'Please update location address',
                   city: 'Please update location city')
  puts 'Building locations complete.'
end

def location_ids
  Location.pluck(:id)
end

def create_users(args)
  puts 'Building default administrators.'
  # Create admins
  admin = User.create!(first_name: 'Admin',
                       last_name: 'Last Name',
                       email: 'admin@mathplusacademy.com',
                       password: 'password',
                       password_confirmation: 'password',
                       location_id: 1,
                       active: true,
                       admin: true,
                       role: 'Admin',
                       subdomain: "#{args[:subdomain]}")

  system_admin = User.create!(first_name: 'System',
                              last_name: 'Administrator',
                              email: 'system_admin@mathplusacademy.com',
                              password: 'vLQdC9ReBVdMvagvL',
                              password_confirmation: 'vLQdC9ReBVdMvagvL',
                              location_id: 1,
                              active: true,
                              admin: true,
                              system_administrator: true,
                              role: 'Admin',
                              subdomain: "#{args[:subdomain]}")
  puts 'Building default administrators complete.'
end

def create_math_courses
  puts 'Building default courses.'
  # Create courses
  course_names_and_descriptions = [
    ['Recruits','KG - 1st Grade'], ['Techs','1st - 2nd Grade'],
    ['Operatives', '2nd - 3rd Grade'], ['Analysts', '3rd - 4th Grade'],
    ['Agents', '4th-5th Grade'], ['Special Ops','5th - 6th Grade'],
    ['Pre-Algebra','6th - 7th Grade'], ['Algebra', '7th - 8th Grade'],
    ['Geometry', '8th - 9th Grade']]

  course_names_and_descriptions.each_with_index do |course_info, i|
    has_assignments = true
    Course.create!(name:              course_info[0],
                   description:       course_info[1],
                   grade:             course_info[1].gsub(' Grade', ''),
                   capacity:          10,
                   occupation_id:     1,
                   has_assignments:   has_assignments)
  end
  puts 'Building default courses complete.'
end

def create_avatars
  puts 'Building default avatars.'
  # Create avatars
  avatar_names = ['Boy', 'Girl', 'Robot']

  avatar_names.each do |name|
    file_name = "MATHPLUS-avatar-#{name.downcase}.png"
    Avatar.create!(name:           name,
                   image:          seed_image('avatars', file_name))
  end
  puts 'Building default avatars complete.'
end

def create_occupations
  puts 'Building default occupations.'
  # Create occupations
  Occupation.create!(title:             'Mathematician',
                     description:       'Your working to master the ins and
                                        outs of mathematics. Keep up the good work and
                                        and good luck on your journey!')

  Occupation.create!(title:             'Engineer',
                     description:       'So you like making things? This is
                                        a great track for your. Keep your nose
                                        to the grindstone and let\'s see what
                                        you can create!')

  Occupation.create!(title:             'Programmer',
                     description:       'It\'s fun telling people to do things
                                        for you. Why not learn to do the same
                                        with computers? They\'re much faster than
                                        humans.')
  puts 'Building default occupations complete.'
end

def create_occupation_levels
  puts 'Building default occupation levels.'
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
  puts 'Building default occupation levels complete.'
end

def badge_names
  ['Attention To Detail', 'Dedication', 'Explorer', 'Helping Others', 'Hot Streak', 'Insightful Questions', 'Mathematician', 'Mental Math', 'Mind Bender', 'Number Cruncher', 'Perfection', 'Positive Attitude', 'Problem Solver', 'Scientist', 'Teamwork']
end

def create_badges
  puts 'Building default badges.'
  # Create badges - A few basic badges are seeded and their images are added as
  # assets. Additional badges can be added and their images uploaded.

  badge_names.each do |name|
    image_file = "MATHPLUS-Badge-#{name.downcase.gsub(' ', '-')}.png"
    Badge.create!(name:     name,
                  image:    seed_image("badges", image_file),
                  multiple: true)
  end
  puts 'Building default badges complete.'
end

def create_experiences
  puts 'Building default experiences.'
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
  puts 'Building default experiences complete.'
end
