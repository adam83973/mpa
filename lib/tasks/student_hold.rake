desc "This task updates hold_status and parent's record in infusionsoft."
task hold_status: :environment do
  students = Student.where('status = ? AND restart_date < ?', "Hold", Date.today + 7.days)
  #Array of group_ids 1738 = Return From Hold, 1734 = Quitting, 1732 = Ready to Return
  @groups = %w(1738 1734 1732)

  students.each do |student|
   if infusion_id = student.user.infusion_id
     #return array of group_ids. These are the tag_ids that are
     #associated with a contact in infusionsoft
     @response = Infusionsoft.contact_load(infusion_id, ["Groups"])
     #convert string of group_ids to array of group_ids
     @user_tags = @response["Groups"].split(",")
     #if user does not have any tags related to hold status
     #it adds the first tag of the sequence
     if (@user_tags & @groups).empty?
       Infusionsoft.contact_add_to_group(infusion_id, "1738")
     elsif !(@user_tags & @groups).empty? && (@user_tags & @groups).include?("1732")
       #runs when customer opts to return
       Infusionsoft.contact_remove_from_group(infusion_id, "1738") #remove return from hold tag
       student.update_attributes({ hold_status: 2 }) #change hold status
     elsif !(@user_tags & @groups).empty? && (@user_tags & @groups).include?("1734")
       #runs when customer opts to quit
       Infusionsoft.contact_remove_from_group(infusion_id, "1738") #remove return from hold tag
       student.update_attributes({ restart_date: nil, hold_status: 3, end_date: Date.today }) #remove restart date/change
     end
   end
  end
end
