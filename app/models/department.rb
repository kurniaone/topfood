class Department < ActiveRecord::Base
  attr_accessible :branch_id, :description, :name
  belongs_to :branch
end
