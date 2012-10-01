class EmployeeDetail < ActiveRecord::Base
  attr_accessible :department_id, :description, :gender, :order_id, :position_id, :quantity, :used_date
  belongs_to :employee_order, foreign_key: 'order_id'
end
