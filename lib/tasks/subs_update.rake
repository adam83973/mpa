# subs = Infusionsoft.data_query('RecurringOrder', 500, 0, {:status => 'Active'}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge, :ContactId] )
#
# subs.each do |sub|
#   if sub['BillingAmt'] == 137.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 147.0})
#   elsif sub['BillingAmt'] == 123.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 133.0})
#   elsif sub['BillingAmt'] == 97.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 107.0})
#   elsif sub['BillingAmt'] == 117.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 127.0})
#   elsif sub['BillingAmt'] == 105.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 110.0})
#   elsif sub['BillingAmt'] == 87.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 97.0})
#   elsif sub['BillingAmt'] == 103.0
#     Infusionsoft.data_update('RecurringOrder', sub['Id'], {:BillingAmt => 110.0})
#   end
# end
#
# a = 0
# b = 0
# c = 0
# d = 0
# amts = []
#
# subs.each do |sub|
#   if sub['BillingAmt'] == 137.0
#     a += 1
#   elsif sub['BillingAmt'] == 123.0
#     b += 1
#   elsif sub['BillingAmt'] == 97.0
#     c += 1
#   elsif sub['BillingAmt'] == 117.0
#     d += 1
#   else
#     amts << sub['BillingAmt']
#   end
# end
#
# puts a
# puts b
# puts c
# puts d
#
# subs.each {|sub| amt << sub['ContactId'] if sub['BillingAmt'] == 103.0}
#
# [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 222.0, 196.0, 105.0, 105.0, 40.0, 105.0, 105.0, 100.0, 147.0, 110.0, 87.0, 103.0, 87.0, 87.0, 103.0, 147.0, 133.0, 147.0, 147.0, 103.0, 147.0, 87.0, 147.0, 132.0, 147.0, 147.0, 147.0, 147.0, 147.0, 133.0, 107.0, 87.0, 147.0, 147.0, 147.0, 147.0, 103.0, 74.0, 147.0, 147.0, 147.0, 133.0, 147.0, 132.0, 132.0, 147.0, 133.0, 147.0, 147.0, 147.0, 147.0, 147.0, 147.0, 147.0, 147.0, 147.0, 133.0, 147.0, 133.0, 147.0, 147.0, 147.0, 107.0, 147.0, 133.0, 147.0, 147.0, 147.0, 147.0, 133.0, 147.0, 147.0, 132.3, 110.25, 147.0, 147.0, 147.0, 147.0, 133.0, 147.0, 107.0, 147.0, 87.0, 147.0, 133.0, 147.0, 147.0, 133.0, 147.0, 147.0]

parents = User.where(active: false, role: "Parent", active_subscription: false, termination_sequence: false)

parents.each do |parent|
  if parent.infusion_id
  invoice = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false).first
  if invoice
    time = invoice['DateCreated'].to_time
      if time < Time.now - 60.days && time > Time.now - 365.days
        parent.update_attribute :termination_sequence, true
      end
    end
  end
end
