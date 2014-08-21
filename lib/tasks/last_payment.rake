namespace :db do
  desc "Update parent's information with last payment date."
  task last_payment: :environment do
    update_last_payment
  end
end

def update_last_payment
  parents = User.where("role = ?", "Parent")
    parents.each do |parent|
      count = 0
    begin
      if parent.infusion_id
        query = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
        query_to_json = query.to_json
          parent.update_attributes last_payment: query_to_json
        active_subscriptions = Infusionsoft.data_query('RecurringOrder', 10, 0, {:ContactId => parent.infusion_id}, [:Id, :ProgramId, :StartDate, :EndDate, :NextBillDate, :BillingAmt, :Qty, :Status, :AutoCharge] )
        if active_subscriptions.any? { |s| s["Status"] == "Active" }
          parent.update_attribute active_subscription: true
        else
          parent.update_attribute active_subscription: false
      else
        parent.update_attributes last_payment: [].to_json
      end
    rescue
      if count > 3
        next
      else
        count = count + 1
        retry
      end
    end
  end
end

