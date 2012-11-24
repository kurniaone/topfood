class OrderDetail < ActiveRecord::Base
  attr_accessible :description, :order_id, :quantity, :unit_id, :used_date
  belongs_to :unit
  belongs_to :purchase_order, foreign_key: 'order_id'
  belongs_to :work_order, foreign_key: 'order_id'

  validates :description, :quantity, :used_date, presence: true
  validates :unit_id, presence: true, if: proc{|od| od.purchase_order.class == PurchaseOrder }
  validates :quantity, numericality: { greater_than: 0 }
end
