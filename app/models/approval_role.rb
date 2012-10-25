class ApprovalRole < ActiveRecord::Base
  belongs_to :approval_setting
  belongs_to :role
  attr_accessible :approval_setting_id, :role_id
  validates :role_id, uniqueness: {scope: :approval_setting_id}
end
