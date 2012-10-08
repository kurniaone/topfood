class Branch < ActiveRecord::Base
  has_many :orders

  attr_accessible :address, :name, :phone, :profile, :center
  validates :name, :address, :phone, presence: true

end
