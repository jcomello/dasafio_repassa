class PerformanceEvaluation < ApplicationRecord
  belongs_to :employee

  validates :title, :description, :employee_id, presence: true
end
