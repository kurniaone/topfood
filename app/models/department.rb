class Department < ActiveRecord::Base
  attr_accessible :description, :name, :code
  validates :name, :code, presence: true
end
