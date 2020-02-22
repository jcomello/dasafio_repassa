class Employee < ApplicationRecord
  include Tokenizable

  has_many :performance_evaluations

  validates :name, presence: true
end
