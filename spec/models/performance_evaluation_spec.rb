require 'rails_helper'

RSpec.describe PerformanceEvaluation, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:employee) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:employee_id) }
  end
end
