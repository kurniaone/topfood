class Position < ActiveRecord::Base
  has_one :user
  belongs_to :top_level, class_name: 'Position', foreign_key: 'parent_id'
  has_many :sub_levels, class_name: 'Position', foreign_key: 'parent_id'

  attr_accessible :code, :name, :description, :level, :parent_id
  validates :code, :name, :level, presence: true
  validates :level, uniqueness: true
end
