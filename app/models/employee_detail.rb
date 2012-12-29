class EmployeeDetail < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :department
  belongs_to :position
  belongs_to :employee_order, foreign_key: 'order_id'

  attr_accessible :department_id, :description, :gender, :order_id, :position_id, :quantity, :used_date
  validates :department_id, :description, :gender, :position_id, :quantity, :used_date, presence: true
end
