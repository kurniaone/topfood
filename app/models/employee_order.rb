class EmployeeOrder < Order
  has_many :employee_details, foreign_key: 'order_id', dependent: :destroy
  validates :employee_details, presence: true, on: :create

  attr_accessible :employee_details_attributes
  accepts_nested_attributes_for :employee_details, :reject_if => proc{|od|
    od['description'].blank? || od['quantity'].blank? || od['gender'].blank? || od['used_date'].blank?
  }, :allow_destroy => true
end