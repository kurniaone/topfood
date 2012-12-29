class Department < ActiveRecord::Base
  acts_as_paranoid

  has_many :employee_details
  attr_accessible :description, :name, :code
  validates :name, :code, presence: true
end
