require 'rails_helper'

RSpec.describe Admin::PerformanceEvaluationsController, type: :controller do
  describe "#create" do
    let(:employee) { FactoryBot.create(:employee) }
    let(:params) do
      {
        title: "Very Good",
        description: "The employee went very well working a lot of tech...",
        employee_id: employee.id
      }
    end

    it "creates a performance evaluation" do
      post :create, params: params
      expect(assigns(:performance_evaluation)).to be_persisted
    end

    it "brings code 201 created" do
      post :create, params: params
      expect(response.code).to eq('201')
    end

    it "responds the created performance evaluation" do
      post :create, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eql("Very Good")
      expect(parsed_response["description"]).to eql("The employee went very well working a lot of tech...")
      expect(parsed_response["employee_id"]).to eql(employee.id)
    end

    context "when params are invalid" do
      let(:params) do
        {
          title: "",
          description: "",
          employee_id: ""
        }
      end

      it "does not create a performance evaluation" do
        post :create, params: params
        expect(assigns(:performance_evaluation)).not_to be_persisted
      end

      it "brings code 422" do
        post :create, params: params
        expect(response.code).to eq('422')
      end

      it "responds the errors" do
        post :create, params: params
        parsed_response = JSON.parse(response.body)

        expect(parsed_response["title"]).to include("can't be blank")
        expect(parsed_response["description"]).to include("can't be blank")
        expect(parsed_response["employee_id"]).to include("can't be blank")
      end
    end
  end
end
