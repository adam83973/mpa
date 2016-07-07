task :mark_xp => :environment do
  ExperiencePoint.find_in_batches.with_index do |group, batch|
    puts "Processing group ##{batch}"
    group.each{|xp| update_negative_attribute(xp)}
  end
end


def update_negative_attribute(xp)
  if xp.points == 0 && xp.experience_id != 3
    xp.update_attribute :negative, true
  else
    xp.update_attribute :negative, false
  end
end
