namespace :badges do
  #Rake task runs at end of day.
  desc "Perform various maintenance tasks."
  task parent_can_request: :environment do
    update_categories
    update_parent_can_request
  end
end

#update categories to say wether they can be requested by parents
def update_categories
  category = Badge.Category.find(6)
  category.update_attribute :parent_can_request, false
end

# edit so parents cannot request certain badges
def update_parent_can_request
  categories = BadgeCategory.where(parent_can_request: false)

  categories.each do |category|
    badges = category.badges
    badges.each do |badge|
      badge.update_attribute :parent_can_request, false
    end
  end
end
