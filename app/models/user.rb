class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
    :lockable, maximum_attempts: 1/0.0, lock_strategy: :failed_attempts, unlock_strategy: :none

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :failed_attempts,
    :name, :phone, :address, :branch_id, :department_id, :position_id, :su, :admin

  has_many :orders, foreign_key: 'created_by'

  def show_captcha?
    u = User.find_by_email(email)
    u && u.failed_attempts >= 3
  end

end
