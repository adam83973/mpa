namespace :db do
  desc "Update parent's information with last payment date."
  task last_payment: :environment do
    update_last_payment
  end
end

def update_last_payment
  parents = User.where("role = ?", "Parent")
    parents.each do |parent|
    begin
      if parent.infusion_id
          parent.update_attributes last_payment: Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
      else
        parent.update_attributes last_payment: "No Infusion Id"
      end
    rescue
      retry
    end
  end
end

