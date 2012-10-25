class Department < ActiveRecord::Base
  has_many :employee_details
  attr_accessible :description, :name, :code
  validates :name, :code, presence: true
end
