orders = Order.all
orders.each do |order|
  approvals = order.approvals
  status    = 'onprocess'
  if order.next_approval.blank? && order.last_approval.approved?
    status = 'approved'
  end

  unless approvals.where("approved = 0").blank?
    status = 'rejected'
  end

  order.update_column(:status, status)
end
