class PurchaseOrder < Order
  has_many :order_details, foreign_key: 'order_id'
  validates :order_details, presence: true

  attr_accessible :order_details_attributes
  accepts_nested_attributes_for :order_details, :reject_if => proc{|od|
    od['description'].blank? || od['quantity'].blank? || od['unit_id'].blank? || od['used_date'].blank?
  }, :allow_destroy => true
end