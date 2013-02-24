class User < ActiveRecord::Base
  acts_as_paranoid
  validates_as_paranoid

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,
    :lockable, maximum_attempts: 1/0.0, lock_strategy: :failed_attempts, unlock_strategy: :none

  belongs_to :role
  has_many :user_branches, dependent: :destroy
  has_many :branches, through: :user_branches
  has_many :orders, foreign_key: 'created_by'


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :failed_attempts,
    :name, :phone, :address, :role_id, :su, :user_branches_attributes

  validates :name, presence: true
  accepts_nested_attributes_for :user_branches, reject_if: proc{|u| u["branch_id"].blank? }, allow_destroy: true

  before_save :ensure_authentication_token

# Class Method
  scope :not_admin, where("su = ?", false)

  def self.role?(code)
    includes(:role).where("roles.code = ?", code.try(:upcase)).try(:first)
  end

  def self.find_by_role_code_and_branch_id(code, branch_id)
    if ['ASM', 'MNG', 'GM'].include?(code.upcase)
      user = find_by_role_code(code)
    else
      user = includes(:role, :user_branches).where("roles.code = ? AND users.id IN
        (SELECT user_id FROM user_branches WHERE branch_id = ?)", code.try(:upcase), branch_id).try(:first)
    end

    user
  end

  def self.find_by_role_code(code)
    includes(:role).where("roles.code = ?", code.try(:upcase)).try(:first)
  end

# Instance Method

  def all_orders(order_class, search = {})
    arr_cond, hash_val = [], {}
    search = {} if search.blank?

    if ['SM', 'TL'].include?(role_code)
      arr_cond << "branch_id IN (SELECT branch_id FROM user_branches WHERE user_id = :user_id)"
      hash_val[:user_id] = id
    # elsif role_code == 'MNG'
    #   arr_cond << "branch_id IN (SELECT branch_id FROM user_branches WHERE user_id IN
    #           (SELECT id FROM users WHERE role_id = (SELECT id FROM roles WHERE code = :code)))"
    #   hash_val[:code] = 'MNG'
    end

    unless search[:order_number].blank?
      arr_cond << "order_number LIKE :order_number"
      hash_val[:order_number] = "%#{search[:order_number]}%"
    end

    unless search[:branch_id].blank?
      arr_cond << "branch_id = :branch_id"
      hash_val[:branch_id] = search[:branch_id]
    end

    if !search[:start_date].blank?
      arr_cond << "(DATE(orders.order_date) BETWEEN DATE(:start_date) AND DATE(:end_date))"
      hash_val[:start_date] = search[:start_date].to_date.try(:strftime, '%Y-%m-%d')
      hash_val[:end_date] = search[:start_date].to_date.try(:strftime, '%Y-%m-%d')

      unless search[:end_date].blank?
        if search[:end_date].to_date > search[:start_date].to_date
          hash_val[:end_date] = search[:end_date].to_date.try(:strftime, '%Y-%m-%d')
        else
          hash_val[:start_date] = search[:end_date].to_date.try(:strftime, '%Y-%m-%d')
          hash_val[:end_date] = search[:start_date].to_date.try(:strftime, '%Y-%m-%d')
        end
      end
    end

    # only approved for implementer
    if Order::Implementer.all.include?(role_code.try(:upcase))
      search[:status] = 'approved'
    end

    if search[:status]
      if search[:status] == 'approved'
        arr_cond << "((SELECT COUNT(id) FROM approvals WHERE order_id = orders.id) = (SELECT COUNT(id) FROM approvals WHERE order_id = orders.id AND approved = 1))"
      end

      if search[:status] == 'rejected'
        arr_cond << "((SELECT COUNT(id) FROM approvals WHERE order_id = orders.id AND approved = 0) > 0)"
      end
    end

    unless search.blank?
      order_class.includes(:user, :branch, :approvals).where(arr_cond.join(" AND "), hash_val)
    else
      order_class.includes(:user, :branch, :approvals).scoped
    end
  end

  def show_captcha?
    u = User.find_by_email(email)
    u && u.failed_attempts >= 3
  end

  def role?(code)
    role.try(:code).try(:downcase) == code.try(:downcase)
  end
  alias :is :role?

  def role_name
    role.try(:name)
  end

  def role_code
    role.try(:code)
  end

  def su?
    su == true
  end

  # get branch for store-manager
  def branch
    branches.try(:first)
  end

  def branch_ids
    branches.map(&:id)
  end

  def implementer?
    Order::Implementer.all.include?(role_code.try(:upcase))
  end

end
