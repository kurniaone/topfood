json.branch_id @order.branch_id
json.order_number @order.order_number
json.order_date @order.order_date
json.status @order.order_status
json.reason @order.rejected? ? @order.rejected_reason : ''

json.created_by @order.user.try(:email)
json.created_at date_time_format(@order.created_at, "%Y-%m-%d %H:%M:%S")
json.updated_at date_time_format(@order.updated_at, "%Y-%m-%d %H:%M:%S")

json.items @order.employee_details do |json, item|
  json.id item.id
  json.description item.description
  json.department_id item.department_id
  json.department_name item.department.name
  json.position_id item.position_id
  json.position_name item.position.name
  json.quantity item.quantity
  json.gender item.gender
  json.used_date item.used_date
end

json.approvals @order.approvals do |json, approval|
  json.user_name approval.user_name || approval.user.try(:name)
  json.email approval.user.try(:email)
  json.approved approval.approved
  json.at date_time_format(approval.do_at, "%Y-%m-%d %H:%M:%S")
end
