class Approval < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  belongs_to :role

  attr_accessible :order_id, :role_id, :role_name, :user_id, :user_name,
    :approved, :do_at, :reason
  validates :order_id, :role_id, :role_name, :user_id, :user_name, presence: true
  validates :role_id, uniqueness: { scope: :order_id }
  validate :approving

  before_save :set_do_at
  after_save  :set_order_status

# CALLBACK
  def set_do_at
    self.do_at = Time.now if self.do_at.blank? && self.approved_changed?
  end

  def set_order_status
    order.rejected! if rejected
    order.approved! if approved && order.next_approval.blank?
  end

  def approving
    errors.add(:approving, " or Rejecting FAILED. Order is already Rejected") if order.rejected
  end

# CLASS METHOD
  def self.last_status
    where("approved IS NOT NULL").try(:last).try(:status)
  end

# INSTANCE METHOD
  def prev
    order.approvals.where("id < ?", id).order("id ASC").try(:last)
  end

  def status
    approved == nil ? (order.next_approval == self && prev.try(:approved) || prev.blank? ? 'Pending' : '') : (approved ? 'Approved' : 'Rejected')
  end

  def pending
    approved == nil && approved != false
  end

  def rejected
    approved != nil && approved == false
  end
end
