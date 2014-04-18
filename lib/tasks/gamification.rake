namespace :db do
  desc "gamification sample data"
  task gamification: :environment do
    make_occupations
    make_levels
  end
end

def make_occupations
  Occupation.create!(title:             "Mathematician",
                     description:       "Your working to master the ins and
                                        outs of math. Keep up the good work and
                                        and good luck on your journey!")

  Occupation.create!(title:             "Engineer",
                     description:       "So you like making things? This is
                                        a great track for your. Keep your nose
                                        to the grind stone and let's see what
                                        you can create!")

  Occupation.create!(title:             "Programmer",
                     description:       "It's fun telling people to do things
                                        for you. Why not learn to do the same
                                        with computers? They're much faster than
                                        humans.")
end

def make_levels
  3.times do |n|

    OccupationLevel.create!(level:                1,
                            points:               1000,
                            rewards:              "Mechanical Pencil & 2 Bonus Credits",
                            privileges:            "Teacher marker coupon",
                            occupation_id:        n)

    OccupationLevel.create!(level:                2,
                            points:               2000,
                            rewards:              "Water Bottle and 2 Bonus Credits",
                            privileges:            "Teacher marker coupon",
                            occupation_id:         n)

    OccupationLevel.create!(level:                3,
                            points:               3000,
                            rewards:              "Backpack and 5 credits",
                            privileges:            "Go first coupon",
                            occupation_id:         n)

    OccupationLevel.create!(level:                4,
                            points:               4000,
                            rewards:              "Medal and 5 credits",
                            privileges:            "Go first coupon",
                            occupation_id:         n)

    OccupationLevel.create!(level:                5,
                            points:               5000,
                            rewards:              "$10 iTunes gift card & 5 credits",
                            privileges:            "Perfect Homework Upgrade",
                            occupation_id:         n)

    OccupationLevel.create!(level:                6,
                            points:               7500,
                            rewards:              "LEGO Party and 10 credits.",
                            privileges:            "Free workshop coupon",
                            occupation_id:         n)
  end
end
