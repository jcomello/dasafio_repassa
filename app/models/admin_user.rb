class AdminUser < ApplicationRecord
  has_many :employees

  validates :name, :token, presence: true

  def initialize(attributes)
    super(attributes)
    self.token ||= SecureRandom.hex
  end
end
