class OrderDetail < ActiveRecord::Base
  attr_accessible :description, :order_id, :quantity, :unit_id, :used_date
  belongs_to :unit
  belongs_to :purchase_order, foreign_key: 'order_id'
  belongs_to :work_order, foreign_key: 'order_id'

  validates :description, :quantity, :unit_id, :used_date, presence: true
end
