class AdminUser < ApplicationRecord
  include Tokenizable

  has_many :employees
  has_many :performance_evaluations, through: :employees

  validates :name, presence: true
end
