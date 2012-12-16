class PurchaseOrder < Order
  has_many :order_details, foreign_key: 'order_id', dependent: :destroy
  validates :order_details, presence: true

  attr_accessible :order_details_attributes
  accepts_nested_attributes_for :order_details, :allow_destroy => true
  validates :order_number, uniqueness: true
end