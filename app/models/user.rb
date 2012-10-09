class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
    :lockable, maximum_attempts: 1/0.0, lock_strategy: :failed_attempts, unlock_strategy: :none

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :failed_attempts,
    :name, :phone, :address, :branch_id, :department_id, :position_id, :management_id, :su, :admin

  validates :management_id, uniqueness: { if: proc{|u| u.management.try(:code).try(:downcase) != 'sm' } }
  validates :management_id, uniqueness: { if: proc{|u| u.management.try(:code).try(:downcase) == 'sm' }, scope: [:branch_id] }
  validates :branch_id, presence: { if: proc{|u| u.management.try(:code).try(:downcase) == 'sm' } }
  validates :name, presence: true

  belongs_to :branch
  belongs_to :management
  belongs_to :position
  has_many :orders, foreign_key: 'created_by'

  scope :not_admin, where("admin = ? AND su = ?", false, false)

  def show_captcha?
    u = User.find_by_email(email)
    u && u.failed_attempts >= 3
  end

end
