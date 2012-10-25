class Position < ActiveRecord::Base
  has_many :employee_details
  attr_accessible :code, :name, :description
  validates :code, :name, presence: true
end
