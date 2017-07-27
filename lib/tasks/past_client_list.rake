# # namespace :operations do
# #   #Rake task runs at end of day.
# #   desc "Perform various maintenance tasks."
# #   task past_client_list: :environment do
# #     past_client_list
# #   end
# # end
# #
def past_client_list
  parents = User.where(active: false, role: "Parent", active_subscription: false)
  past_clients = []
  parents.each do |parent|
    if parent.infusion_id
      invoice = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false).first
      if invoice
        time = invoice['DateCreated'].to_time
        # Check to see if they a 60 days past
        if time < Time.now - 30.days
          infusionsoft_contact = Infusionsoft.contact_load(parent.infusion_id, [:Id, :FirstName, :LastName, :ContactType, :Email, :Phone1Type, :Phone1, :Phone2Type, :Phone2, :StreetAddress1, :PostalCode, :City, :State])
          children = load_students(parent)
          past_clients << [parent.id, time]
          # past_client << "#{parent.id}, #{time}, #{parent.full_name}, #{parent.email}, #{infusionsoft_contact['StreetAddress1']} #{infusionsoft_contact['City']} #{infusionsoft_contact['State']} #{infusionsoft_contact['PostalCode']}, #{children}"
        end
      end
    end
  end
  past_clients
end
#
#   def to_csv
#     # tmp/csv/past_clients.csv
#     file = CSV.generate do |csv|
#       # set CSV headers
#       column_names = ["id", "time", "fullname", "email", "address", "children"]
#       # add headers
#       csv << column_names
#       past_clients.each do |client|
#         csv << client
#       end
#     end
#   end
# end
#
#
# def load_students(parent)
#   students = parent.students
#   children = ""
#   students.each do |student|
#     student_info = "#{student.full_name} ("
#     student_courses = ""
#     student.registrations.each{|reg| student_courses = student_courses + "#{reg.course.name}" if reg && reg.course }
#     student_info = student_info + student_courses + ")"
#     children = children + " #{student_info}"
#   end
#   children
# end
# #
# # infusion = Infusionsoft.contact_load(10729, [:Id, :FirstName, :LastName, :ContactType, :Email, :Phone1Type, :Phone1, :Phone2Type, :Phone2, :StreetAddress1, :PostalCode, :City, :State])
# #
# # "#{infusion['StreetAddress1']} #{infusion['City']} #{infusion['State']} #{infusion['PostalCode']}"
# count = 0
# past_clients.each do |client|
#   id = client[0]
#   parent = User.find id
#   if parent.infusion_id
#     if !client[1].blank? && Time.parse("#{client[1]}") > Time.now - 1.year
#       Infusionsoft.contact_add_to_group(parent.infusion_id, 2282)
#     end
#   end
# end
