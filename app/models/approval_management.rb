class ApprovalManagement < ActiveRecord::Base
  belongs_to :approval_setting
  attr_accessible :approval_setting_id, :management_id

  validates :approval_setting_id, :management_id, presence: true
  validates :management_id, uniqueness: { scope: :approval_setting_id }
end
