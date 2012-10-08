class Management < ActiveRecord::Base
  has_one :user
  belongs_to :main_level, class_name: 'Management', foreign_key: :parent_id
  has_many :sub_levels, class_name: 'Management', foreign_key: :parent_id, dependent: :destroy

  accepts_nested_attributes_for :sub_levels, reject_if: proc{|sl| sl['code'].blank? || sl['name'].blank? }

  attr_accessible :code, :description, :level, :name, :parent_id
  validates :code, :name, :level, presence: true
  validates :level, uniqueness: true
end
