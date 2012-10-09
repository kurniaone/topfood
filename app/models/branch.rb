class Branch < ActiveRecord::Base
  has_many :orders
  has_many :users

  attr_accessible :address, :name, :phone, :profile, :center
  validates :name, :address, :phone, presence: true

  scope :not_center, where("center = ? OR center IS NULL", false)

  def store_manager
    users.select{|u| u.management.try(:code) == 'SM' }.try(:first)
  end
end
