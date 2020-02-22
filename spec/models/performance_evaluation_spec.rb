require 'rails_helper'

RSpec.describe PerformanceEvaluation, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:employee) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:employee_id) }

    context "validate employee" do
      let(:admin_user) { FactoryBot.create(:admin_user) }

      context "when employee is from the same user admin" do
        let(:employee) { FactoryBot.create(:employee, admin_user_id: admin_user.id) }

        subject { FactoryBot.build(:performance_evaluation, employee_id: employee.id, current_admin_user: admin_user) }

        it { is_expected.to be_valid }

        it "does not add errors" do
          subject.valid?
          expect(subject.errors).to be_empty
        end
      end

      context "when employee is from another user admin" do
        let(:other_admin_user) { FactoryBot.create(:admin_user) }
        let(:employee) { FactoryBot.create(:employee, admin_user_id: other_admin_user.id) }

        subject { FactoryBot.build(:performance_evaluation, employee_id: employee.id, current_admin_user: admin_user) }

        it { is_expected.to be_invalid }

        it "adds errors" do
          subject.valid?
          expect(subject.errors["employee_id"]).to include("does not exist")
        end
      end
    end
  end
end
