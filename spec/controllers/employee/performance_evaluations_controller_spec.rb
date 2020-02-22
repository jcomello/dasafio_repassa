require 'rails_helper'

RSpec.describe Employee::PerformanceEvaluationsController, type: :controller do
  let!(:employee) { FactoryBot.create(:employee) }

  before { api_sign_in(employee) }

  describe "#index" do
    let(:other_employee) { FactoryBot.create(:employee) }

    let!(:evaluation1) { FactoryBot.create(:performance_evaluation, title: "Very well", employee: employee) }
    let!(:evaluation2) { FactoryBot.create(:performance_evaluation, title: "Good, but not really", employee: employee) }
    let!(:evaluation3) { FactoryBot.create(:performance_evaluation, title: "Worse job ever", employee: employee) }
    let!(:evaluation_from_another_user_admin) { FactoryBot.create(:performance_evaluation, employee_id: other_employee.id) }

    it "assigns the performance_evaluations" do
      get :index
      expect(assigns(:performance_evaluations)).to contain_exactly(evaluation1, evaluation2, evaluation3)
    end

    it "brings code 200 ok" do
      get :index
      expect(response.code).to eq('200')
    end

    it "responds the evaluations" do
      get :index
      parsed_response = JSON.parse(response.body).map { |hash| hash["title"] }

      expect(parsed_response).to contain_exactly("Very well", "Good, but not really", "Worse job ever")
    end
  end
end
