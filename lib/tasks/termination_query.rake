desc "Query parents who have quit within the last 12 months and haven't returned."
task termination_query: :environment do
  run_query
end

def run_query
  parents = User.where(role: "Parent")
  non_restarts = []

  parents.each do |parent|
    if parent.infusion_id
      invoice = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => parent.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false).first
      if invoice
        time = invoice['DateCreated'].to_time
        if time < Time.now - 60.days && time > Time.now - 1095.days
          non_restarts << parent
        end
      end
    end
  end

  spreadsheet = CSV.generate do |csv|
    csv.add_row User.column_names
    non_restarts.each do |parent|
      csv.add_row parent.attributes.values_at(*User.column_names)
    end
  end

  puts spreadsheet
end
