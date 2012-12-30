class Order < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user, foreign_key: 'created_by'
  belongs_to :branch
  has_many :approvals
  has_many :apps_orders

  attr_accessible :branch_id, :created_by, :order_number, :type, :order_date, :last_app_id, :updated_by
  validates :branch_id, :created_by, :order_number, :type, presence: true
  validates :order_number, uniqueness: true

  after_create :generate_approvals, :generate_apps_orders
  after_update :update_apps_orders

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

  def generate_apps_orders
    attrs, app_ids = [], AppsOrder.app_ids

    app_ids.each do |app_id|
      t = Time.now
      app_timestamp = app_id == updated_by ? t : t - 1.day

      attrs << {
        order_id: id,
        app_id: app_id,
        order_timestamp: t,
        app_timestamp: app_timestamp
      }
    end

    AppsOrder.create(attrs)
  end

  def update_apps_orders
    t = Time.now
    if updated_by == 'server'
      AppsOrder.update_all(["order_timestamp = ?", t], ["order_id = ?", id])
    else
      app_order.update_attributes(app_timestamp: t) if app_order = apps_orders.find_by_app_id(updated_by)
    end
  end

# CLASS METHOD

  def self.to_sync(app_id)
    includes(:apps_orders)
    .where("id IN
      (SELECT order_id FROM apps_orders WHERE app_id = ? AND
        (TIMESTAMP(order_timestamp) > TIMESTAMP(app_timestamp)))", app_id)
  end

  def self.sync(class_name, orders, user, app_id)
    results, errors = [], []
    orders.each do |o|
      params = o[:params].merge(updated_by: app_id)
      order = class_name.find_by_order_number(params[:order_number])

      if o[:action].try(:downcase) == 'create'
        order = class_name.create(params)
        results << {
          action: o[:action],
          order_number: params[:order_number],
          success: order.try(:errors).blank?,
          errors: order.try(:errors).try(:full_messages),
          object: order,
          items: order.order_details
        }

      elsif o[:action].try(:downcase) == 'update'
        order.update_attributes(params)
        results << {
          action: o[:action],
          order_number: params[:order_number],
          success: order.try(:errors).blank?,
          errors: order.try(:errors).try(:full_messages),
          object: order,
          items: order.order_details
        }

      elsif o[:action].try(:downcase) == 'delete'
        errors << "Order not found" unless order
        errors << "Order can not be deleted" if order && !order.destroy && order.update_attributes(updated_by: app_id)

        results << {
          action: o[:action],
          order_number: params[:order_number],
          success: errors.blank?,
          errors: errors,
          object: order,
          items: order.order_details
        }

      elsif o[:action].try(:downcase) == 'approve'
        errors << "Next approver is #{order.next_approver.role_name}" unless order.next_approver == user
        approval = order.next_approval
        approval.update_attributes(approved: params[:approved]) && order.update_attributes(updated_by: app_id) if errors.blank?

        results << {
          action: o[:action],
          order_number: params[:order_number],
          success: errors.blank?,
          errors: errors,
          object: approval,
          items: order.order_details
        }

      else
        results << { warning: "some items can not be processed" }
      end

    end

    results
  end

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

  def next_approval
    pending_approvals.try(:first)
  end

  def next_approver
    next_approval.try(:user)
  end

  def next_approver_role
    next_approver.try(:role)
  end

  def last_approval
    approvals.where("approved IS NOT NULL").try(:last)
  end

  def last_approver
    last_approval.try(:user)
  end

  def last_approver_role
    last_approver.try(:role)
  end

  def order_status
    next_approver && !rejected ? "Waiting \"#{next_approver.role.name}\" approval" : "#{last_approval.status} by #{last_approver.role.name}"
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
    !approvals.where("approved = 0").blank?
  end

  def send_email_to_approver(url)
    AppMailer.send_notification_to_approver(self, next_approver, url).deliver if next_approver
  end

  def show_link_for(user, approval)
    !rejected && next_approver == user && next_approver_role == approval.role && approval.pending
  end

end
