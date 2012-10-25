class Order < ActiveRecord::Base
  belongs_to :user, foreign_key: 'created_by'
  belongs_to :branch
  has_many :approvals

  attr_accessible :branch_id, :created_by, :order_number, :type, :order_date
  validates :branch_id, :created_by, :order_number, :type, presence: true
  validates :order_number, :uniqueness => true

  scope :by_store_manager, lambda{|sm|
    includes(:user, :branch, :approvals).where("branch_id IN (SELECT branch_id FROM user_branches WHERE user_id = ? )", sm.id)
  }
  scope :by_team_leader, lambda{|tl|
    includes(:user, :branch, :approvals).where("branch_id IN (SELECT branch_id FROM user_branches WHERE user_id = ? )", tl.id)
  }
  scope :by_manager, lambda{|mng|
    includes(:user, :branch, :approvals).where("branch_id IN (SELECT branch_id FROM user_branches WHERE user_id IN
      (SELECT id FROM users WHERE role_id = (SELECT id FROM roles WHERE code = ?)))", 'MNG')
  }

  # Generate order number
  def generate_order_number
    r = Random.new
    "#{self.class.to_s.gsub(/[a-z]/, '')}#{Time.now.to_i}"
  end

  def no_approval
    approvals.blank?
  end

  def order_status
    status = 'Approved'
    approver_roles.each do |ar|
      if approvals.find_by_role_id(ar.id).blank?
        status = "Waiting \"#{ar.name}\" approval"
        break
      end
    end

    status
  end

  def approver_roles
    center = branch.center == true
    setting = ApprovalSetting.find_by_order_class_and_center(self.class, center)
    setting.roles
  end

  def approver_by_role(role_code)
    User.includes(:role, :user_branches).where("roles.code = ? AND user_branches.branch_id = ?", role_code.try(:upcase), branch_id).try(:first)
  end

  def approved
    approver_roles.size == approvals.size
  end

  def send_email_to_approver(url)
    role_code = approver_roles.first.code
    approver = approver_by_role(role_code)

    AppMailer.send_notification_to_approver(self, approver, url).deliver
  end

end
