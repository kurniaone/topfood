class MasterDepartment < ActiveRecord::Base
  attr_accessible :code, :description, :name
  validates :code, :name, presence: true
end
