require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:employees) }
    it { is_expected.to have_many(:performance_evaluations).through(:employees) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:token) }
  end

  describe "#initialize" do
    it "sets token value by default" do
      expect(subject.token).to be_present
    end

    context "when a token is sent as a parameter" do
      subject { described_class.new(token: "some-token") }

      it "sets the passed token" do
        expect(subject.token).to eql("some-token")
      end
    end
  end
end


