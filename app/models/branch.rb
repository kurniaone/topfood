class Branch < ActiveRecord::Base
  acts_as_paranoid

  has_many :orders
  has_many :user_branches
  has_many :users, through: :user_branches

  attr_accessible :address, :name, :phone, :profile, :center
  validates :name, :address, :phone, presence: true

  scope :not_center, where("center = ? OR center IS NULL", false)

  def store_manager
    users.select{|u| u.role?('sm') }.try(:first)
  end

  def user(code)
    users.select{|u| u.role?(code) }.try(:first) || User.role?(code)
  end
end
