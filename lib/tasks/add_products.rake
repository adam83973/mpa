namespace :db do
  desc "Fill database with sample data"
  task add_products: :environment do
    add_products
  end
end

def add_products

  if Rails.env.development?
    quantity = 10
  elsif Rails.env.production?
    quantity = 0
  end

  # add set to product list
  3.times do |n|
    Product.create!(name:               "Set",
                 location_id:           n+1,
                 sku:                   "736396001009",
                 price:                 1099,
                 credits:               15,
                 quantity:              quantity)
  end
  # add chocolate fix to product list
  3.times do |n|
    Product.create!(name:               "Chocolate Fix",
                 location_id:           n+1,
                 sku:                   "019275015305",
                 price:                 1799,
                 credits:               24,
                 quantity:              quantity)
  end
  # add distraction to product list
  3.times do |n|
    Product.create!(name:               "Distraction",
                 location_id:           n+1,
                 sku:                   "019275015145",
                 price:                 1299,
                 credits:               17,
                 quantity:              quantity)
  end
  # add Forbidden Desert to product list
  3.times do |n|
    Product.create!(name:               "Forbidden Desert",
                 location_id:           n+1,
                 sku:                   "759751004156",
                 price:                 1699,
                 credits:               23,
                 quantity:              quantity)
  end
  # add Hive to product list
  3.times do |n|
    Product.create!(name:               "Hive",
                 location_id:           n+1,
                 sku:                   "4260071875150",
                 price:                 2999,
                 credits:               40,
                 quantity:              quantity)
  end
  # add Little Hands Card Holder to product list
  3.times do |n|
    Product.create!(name:               "Little Hands Card Holder",
                 location_id:           n+1,
                 sku:                   "759751007034",
                 price:                 399,
                 credits:               5,
                 quantity:              quantity)
  end
  # add Loot to product list
  3.times do |n|
    Product.create!(name:               "Loot",
                 location_id:           n+1,
                 sku:                   "759751002312",
                 price:                 1099,
                 credits:               15,
                 quantity:              quantity)
  end
  # add Math Dice to product list
  3.times do |n|
    Product.create!(name:               "Math Dice",
                 location_id:           n+1,
                 sku:                   "019275015107",
                 price:                 599,
                 credits:               8,
                 quantity:              quantity)
  end
  # add Math Dice Jr. to product list
  3.times do |n|
    Product.create!(name:               "Math Dice Jr.",
                 location_id:           n+1,
                 sku:                   "019275015152",
                 price:                 599,
                 credits:               8,
                 quantity:              quantity)
  end
  # add Square Up to product list
  3.times do |n|
    Product.create!(name:               "Square Up",
                 location_id:           n+1,
                 sku:                   "736970360065",
                 price:                 1999,
                 credits:               27,
                 quantity:              quantity)
  end
  # add Quirkle to product list
  3.times do |n|
    Product.create!(name:               "Quirkle",
                 location_id:           n+1,
                 price:                 2495,
                 credits:               34,
                 quantity:              quantity)
  end
  # add Prime Climb to product list
  3.times do |n|
    Product.create!(name:               "Prime Climb",
                 location_id:           n+1,
                 sku:                   "863002000108",
                 price:                 3499,
                 credits:               46,
                 quantity:              quantity)
  end
  # add Rat-a-Tat Cat to product list
  3.times do |n|
    Product.create!(name:               "Rat-a-Tat Cat",
                 location_id:           n+1,
                 sku:                   "759751002046",
                 price:                 1099,
                 credits:               15,
                 quantity:              quantity)
  end
  # add Rush Hour to product list
  3.times do |n|
    Product.create!(name:               "Rush Hour",
                 location_id:           n+1,
                 sku:                   "019275050009",
                 price:                 1999,
                 credits:               27,
                 quantity:              quantity)
  end
  # add Q-bits to product list
  3.times do |n|
    Product.create!(name:               "Q-bits",
                 location_id:           n+1,
                 price:                 2499,
                 credits:               33,
                 quantity:              quantity)
  end
  # add Shape by Shape to product list
  3.times do |n|
    Product.create!(name:               "Shape by Shape",
                 location_id:           n+1,
                 sku:                   "019275059415",
                 price:                 1499,
                 credits:               20,
                 quantity:              quantity)
  end
  # add Sleeping Queens to product list
  3.times do |n|
    Product.create!(name:               "Seeping Queens",
                 location_id:           n+1,
                 sku:                   "759751002305",
                 price:                 1099,
                 credits:               15,
                 quantity:              quantity)
  end
  # add Solitaire Chess to product list
  3.times do |n|
    Product.create!(name:               "Solitaire Chess",
                 location_id:           n+1,
                 sku:                   "759751002305",
                 price:                 1999,
                 credits:               27,
                 quantity:              quantity)
  end
  # add Swish to product list
  3.times do |n|
    Product.create!(name:               "Swish",
                 location_id:           n+1,
                 sku:                   "019275015121",
                 price:                 1399,
                 credits:               19,
                 quantity:              quantity)
  end
  # add Tilt to product list
  3.times do |n|
    Product.create!(name:               "Tilt",
                 location_id:           n+1,
                 sku:                   "019275010010",
                 price:                 1999,
                 credits:               27,
                 quantity:              quantity)
  end
  # add Zeus On The Loose to product list
  3.times do |n|
    Product.create!(name:               "Zeus on the Loose",
                 location_id:           n+1,
                 sku:                   "759751002336",
                 price:                 1099,
                 credits:               15,
                 quantity:              quantity)
  end
end
