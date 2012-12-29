class Unit < ActiveRecord::Base
  acts_as_paranoid

  has_many :order_details

  attr_accessible :code, :name
  validates :code, :name, presence: true
  validates :code, uniqueness: true
end
