class Branch < ActiveRecord::Base
  attr_accessible :address, :center, :name, :phone, :profile
  has_many :department
  has_many :position
  has_many :orders
  has_many :users


  def store_manager
    !center && users.where("position_id = ?", SM_ID)
  end
end
