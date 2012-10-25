class Approval < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  belongs_to :role

  attr_accessible :order_id, :role_id, :role_name, :user_id, :user_name, :approved, :do_at
end
