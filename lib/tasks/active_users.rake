namespace :tag do
  desc "Tag active users infusionsoft accounts with month day year active tag."
  task active_parents: :environment do
    tag_parents
  end
  task new_albany_parents: :environment do
    tag_new_albany_parents
  end
  task powell_parents: :environment do
    tag_powell_parents
  end
end

def tag_parents
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true)
  # create tag unique to month day and year and associate it with active_tags category
  group_id = set_active_parents

  process_tags(parents, group_id)

  puts group_id
end

def tag_new_albany_parents
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true).where(location_id: 2)
  # create tag unique to month day and year and associate it with active_tags category
  group_id = set_active_parents("new_albany")

  process_tags(parents, group_id)

  puts group_id
end

def tag_powell_parents
  # pull parents that are active
  parents = User.where(role:"Parent").where(active: true).where(location_id: 1)
  # create tag unique to month day and year and associate it with active_tags category
  group_id = set_active_parents("powell")

  process_tags(parents, group_id)

  puts group_id
end

def set_active_parents(location=nil)
  location ? text = "_#{location.downcase.tr(' ', '_')}" : text = ""
  group_id = Infusionsoft.data_add('ContactGroup', {GroupName: "#{text}_#{Date.today.month}_#{Date.today.day}_#{Date.today.year}_active#{text}", GroupCategoryId: 78})
  group_id
end

def process_tags(parents, group_id)
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
