namespace :infusionsoft do
  desc "Update parent's record with various information from Infusionsoft."
  task daily_maintenance: :environment do
    subscription_information
  end
end

def subscription_information
  parents = User.where("role = ?", "Parent")
    parents.each do |parent|
      count = 0
    begin
      if parent.infusion_id
        # Pull invoices
        invoices = Infusionsoft.data_query_order_by('Invoice', 10, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
        if invoices
          # Remove invoices that are paid
          invoices.delete_if{|invoice| invoice["PayStatus"] != 0}
          # Sum outstanding balances and add to parent record
          parent.update_attribute :balance_due, invoices.sum{ |invoice| invoice["TotalDue"] }.to_i
        # Update active_subscription attribute if parent has active subscription
        end
        if parent.active_subscription?
          parent.update_attributes active_subscription: true,
            subscription_count: parent.subscriptions_count.to_i
        else
          parent.update_attributes active_subscription: false, subscription_count: 0
        end
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
