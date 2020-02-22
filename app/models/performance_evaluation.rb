class PerformanceEvaluation < ApplicationRecord
  attr_accessor :current_admin_user

  belongs_to :employee

  validates :title, :description, :employee_id, presence: true
  validate :employee_existence

  private

  def employee_existence
    return if current_admin_user.blank?
    return if current_admin_user.id == employee&.admin_user_id
    errors.add(:employee_id, "does not exist")
  end
end
