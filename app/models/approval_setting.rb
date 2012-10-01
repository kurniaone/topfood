class ApprovalSetting < ActiveRecord::Base
  attr_accessible :branch_id, :order_class, :position_id
  belongs_to :branch
  belongs_to :position
end
