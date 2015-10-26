namespace :tag do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task active_parents: :environment do
    tag_parents
  end
  task new_albany_parents: :environment do
    tag_new_albany_parents
  end
end

def tag_parents
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true)
  # create tag unique to month day and year and associate it with active_tags category
  set_active_parents

  process_tags(parents)

  puts group_id
end

def tag_users_new_albany
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true).where(location_id: 2)
  # create tag unique to month day and year and associate it with active_tags category
  set_active_parents(new_albany)

  process_tags

  puts group_id
end

def set_active_parents(location=nil)
  location ? text = "_#{location.downcase.tr(' ', '_')}" : text = ""
  group_id = Infusionsoft.data_add('ContactGroup', {GroupName: "#{Date.today.month}_#{Date.today.day}_#{Date.today.year}_active#{text}", GroupCategoryId: 78})
end

def process_tags(parents)
  parents.each_with_index do |parent, n|
    unless parent.infusion_id.nil?
      if result = Infusionsoft.contact_add_to_group(parent.infusion_id, group_id)
        puts "#{n}/#{parents.count}"
      else
        puts "Error user_id #{parent.id}, infusion_id: #{parent.infusion_id}"
      end
    else
      puts "No infusionsoft id for user #{parent.id}"
    end
  end
end
