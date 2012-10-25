class UserBranch < ActiveRecord::Base
  belongs_to :user
  belongs_to :branch
  attr_accessible :branch_id, :user_id, :role_id
  validates :branch_id, uniqueness: {scope: :role_id}
end
