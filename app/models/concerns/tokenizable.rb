module Tokenizable
  extend ActiveSupport::Concern

  included do
    validates :token, presence: true
  end

  def initialize(attributes)
    super(attributes)
    self.token ||= SecureRandom.hex
  end
end
