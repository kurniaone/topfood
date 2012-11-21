class Order < ActiveRecord::Base
  belongs_to :user, foreign_key: 'created_by'
  belongs_to :branch
  has_many :approvals

  attr_accessible :branch_id, :created_by, :order_number, :type, :order_date
  validates :branch_id, :created_by, :order_number, :type, presence: true
  validates :order_number, :uniqueness => true

  after_create :generate_approvals

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

# CALLBACK

  def generate_approvals
    approver_roles.each do |role|
      user = User.find_by_role_code_and_branch_id(role.code, branch_id)
      ap = approvals.create(
        role_id:    role.id,
        role_name:  role.name,
        user_id:    user.try(:id),
        user_name:  user.try(:name)
      )
    end
  end

# CLASS METHOD

# INSTANCE METHOD

  # Generate order number
  def generate_order_number
    r = Random.new
    "#{self.class.to_s.gsub(/[a-z]/, '')}#{Time.now.to_i}"
  end

  def no_approval
    pending_approvals.size == approver_roles.size
  end

  def pending_approvals
    approvals.where("approved IS NULL")
  end

  def next_approver
    pending_approvals.try(:first).try(:user)
  end

  def next_approver_role
    next_approver.role
  end

  def order_status
    next_approver ? "Waiting \"#{next_approver.role.name}\" approval" : approvals.last.status
  end

  def approval_settings
    center = branch.center == true
    ApprovalSetting.includes(:roles).find_by_order_class_and_center(self.class, center)
  end

  def approver_roles
    approval_settings.roles
  end

  def approver_by_role(role_code)
    User.includes(:role, :user_branches).where("roles.code = ? AND user_branches.branch_id = ?", role_code.try(:upcase), branch_id).try(:first)
  end

  def approved
    next_approver.blank? && approvals.last.approved
  end

  def rejected
    next_approver.blank? && approvals.last.rejected
  end


  def send_email_to_approver(url)
    AppMailer.send_notification_to_approver(self, next_approver, url).deliver if next_approver
  end

  def show_link_for(user, approval)
    next_approver == user && next_approver_role == approval.role && approval.pending
  end

end
