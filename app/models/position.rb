class Position < ActiveRecord::Base
  attr_accessible :branch_id, :department_id, :description, :name, :level, :parent_id
  belongs_to :branch
  belongs_to :department
  belongs_to :top_level, class_name: 'Position', foreign_key: 'parent_id'
  has_many :sub_levels, class_name: 'Position', foreign_key: 'parent_id'

end
