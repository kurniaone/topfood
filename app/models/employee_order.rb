class EmployeeOrder < Order
  has_many :employee_details, foreign_key: 'order_id'
end