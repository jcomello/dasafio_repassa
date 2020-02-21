class Employee < ApplicationRecord
  has_many :performance_evaluations

  validates :name, presence: true
end
