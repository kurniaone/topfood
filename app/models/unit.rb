class Unit < ActiveRecord::Base
  has_many :order_details

  attr_accessible :code, :name
  validates :code, :name, presence: true
end
