class Employee < ApplicationRecord
  has_many :perfomance_evaluations

  validates :name, presence: true
end
