class ApprovalSetting < ActiveRecord::Base
  has_many :approval_roles
  has_many :roles, through: :approval_roles
  attr_accessible :order_class, :center, :approval_roles_attributes
  validates :order_class, presence: true

  accepts_nested_attributes_for :approval_roles, reject_if: proc {|ap| ap['role_id'].blank? }, allow_destroy: true
end
