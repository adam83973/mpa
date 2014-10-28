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
      # if a parent has an infusion_id, update last_payment attribute and active_subscription attribute
      if parent.infusion_id
        query = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
        query_to_json = query.to_json
          parent.update_attributes last_payment: query_to_json
        #update active_subscription attribute if parent has active subscription
        if parent.active_subscription?
          parent.update_attributes active_subscription: true, subscription_count: parent.subscriptions_count.to_i
        else
          parent.update_attributes active_subscription: false
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

