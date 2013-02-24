orders = Order.all
orders.each do |order|
  status = order.approved ? 'approved' : (order.rejected ? 'rejected' : 'onprocess')
  order.update_column(:status, status)
end
