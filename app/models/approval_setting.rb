class ApprovalSetting < ActiveRecord::Base
  has_many :approval_managements
  attr_accessible :order_class, :approval_managements_attributes
  validates :order_class, presence: true

  accepts_nested_attributes_for :approval_managements, reject_if: proc {|ap| ap['management_id'].blank? }, :allow_destroy => true
end
