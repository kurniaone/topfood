class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
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

  # Class Method
  scope :not_admin, where("su = ?", false)

  def self.role?(code)
    includes(:role).where("roles.code = ?", code.try(:upcase)).try(:first)
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

  # get branch for store-manager
  def branch
    branches.try(:first)
  end


end
