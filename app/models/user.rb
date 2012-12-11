class User < ActiveRecord::Base
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
      user = includes(:role).where("roles.code = ?", code.try(:upcase)).try(:first)
    else
      user = includes(:role, :user_branches).where("roles.code = ? AND users.id IN
        (SELECT user_id FROM user_branches WHERE branch_id = ?)", code.try(:upcase), branch_id).try(:first)
    end

    user
  end

# Instance Method

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

end
