class EmployeeOrder < Order
  has_many :employee_details, foreign_key: 'order_id', dependent: :destroy
  validates :employee_details, presence: true, on: :create

  attr_accessible :employee_details_attributes
  accepts_nested_attributes_for :employee_details, :allow_destroy => true
  validates :order_number, uniqueness: true


  def order_details
    employee_details
  end
end