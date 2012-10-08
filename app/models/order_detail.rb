class OrderDetail < ActiveRecord::Base
  attr_accessible :description, :order_id, :quantity, :unit_id, :used_date
  belongs_to :purchase_order, foreign_key: 'order_id'
  belongs_to :work_order, foreign_key: 'order_id'

  validates :description, :order_id, :quantity, :unit_id, :used_date, presence: true
end
