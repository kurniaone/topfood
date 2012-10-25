class Role < ActiveRecord::Base
  has_many :users
  attr_accessible :code, :name, :description
  validates :code, :name, presence: true

  before_save :upcase_code

  def upcase_code
    self.code.try(:upcase!)
  end
end
