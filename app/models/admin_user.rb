class AdminUser < ApplicationRecord
  has_many :employees
  has_many :performance_evaluations, through: :employees

  validates :name, :token, presence: true

  def initialize(attributes)
    super(attributes)
    self.token ||= SecureRandom.hex
  end
end
