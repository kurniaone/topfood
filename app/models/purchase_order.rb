class PurchaseOrder < Order
  has_many :order_details, foreign_key: 'order_id'
end