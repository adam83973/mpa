# result = woocommerce.get("orders", {filter: {limit: 500} }).parsed_response
#
# result = woocommerce.get("orders", {filter: {limit: 250} }).parsed_response
#
# orders = result['orders']
#
# columns = ["name", "email", "phone", "item"]
#
#
# file = CSV.open('tmp/csv/woo_orders.csv', 'w') do |csv|
#   csv << columns
#   orders.each do |order|
#     client_info = set_client_info(order)
#     csv << client_info
#   end
# end
#
# file = CSV.generate do |csv|
#   csv << columns
#   orders.each do |order|
#     unless User.where("first_name = ? and last_name = ?", order['billing_address']['first_name'], order['billing_address']['last_name']).any?
#       client_info = set_client_info(order)
#       csv << client_info
#     end
#   end
# end
#
# def set_client_info(order)
#   client_info = []
#   client_info << "#{order['billing_address']['first_name']} #{order['billing_address']['last_name']}"
#   client_info << "#{order['billing_address']['email']}"
#   client_info << "#{order['billing_address']['phone']}"
#   client_info << "#{(order['line_items'].first)['name']}" if order['line_items'].first
#   client_info
# end
