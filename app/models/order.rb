class Order < ActiveRecord::Base
  attr_accessible :branch_id, :created_by, :order_number, :type
  belongs_to :user, foreign_key: 'created_by'

  validates :branch_id, :created_by, :order_number, :type, presence: true
end
