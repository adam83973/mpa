namespace :tag do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task active_users: :environment do
    tag_users
  end
  task active_new_albany: :environment do
    tag_users_new_albanvy
  end
end

def tag_users
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true)
  # create tag unique to month day and year and associate it with active_tags category
  group_id = Infusionsoft.data_add('ContactGroup', {GroupName: "#{Date.today.month}_#{Date.today.day}_#{Date.today.year}_active", GroupCategoryId: 78})
  parents.each_with_index do |parent, n|
    result = Infusionsoft.contact_add_to_group(parent.infusion_id, group_id) unless parent.infusion_id.nil?
    puts "#{n}/#{parents.count}"
  end
  puts group_id
end

def tag_users_new_albanvy
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true).where(location_id: 2)
  # create tag unique to month day and year and associate it with active_tags category
  group_id = Infusionsoft.data_add('ContactGroup', {GroupName: "#{Date.today.month}_#{Date.today.day}_#{Date.today.year}_active_new_albany", GroupCategoryId: 78})
  parents.each_with_index do |parent, n|
    result = Infusionsoft.contact_add_to_group(parent.infusion_id, group_id) unless parent.infusion_id.nil?
    puts "#{n}/#{parents.count}"
  end
  puts group_id
end
