require 'rails_helper'

RSpec.describe Admin::PerformanceEvaluationsController, type: :controller do\
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:employee) { FactoryBot.create(:employee, admin_user_id: admin_user.id) }

  before { api_sign_in(admin_user) }


  describe "#index" do
    let!(:other_admin_user) { FactoryBot.create(:admin_user) }
    let(:other_employee) { FactoryBot.create(:employee, admin_user_id: other_admin_user.id) }

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

  describe "#create" do
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

      context "when employee setted is from another admin_user" do
        let!(:other_admin_user) { FactoryBot.create(:admin_user) }
        let(:employee) { FactoryBot.create(:employee, admin_user_id: other_admin_user.id) }
        let(:params) do
          {
            title: "Nice",
            description: "some text about the employee",
            employee_id: employee.id
          }
        end

        it "responds the errors" do
          post :create, params: params
          parsed_response = JSON.parse(response.body)

          expect(parsed_response["employee_id"]).to include("does not exist")
        end
      end
    end
  end

  describe "#update" do
    let(:other_employee) { FactoryBot.create(:employee, name: "Johnny Winter", admin_user_id: admin_user.id) }
    let!(:performance_evaluation) { FactoryBot.create(:performance_evaluation, title: "Good, but not really", employee: employee) }

    let(:params) do
      {
        id: performance_evaluation.id,
        title: "Not so good",
        employee_id: other_employee.id
      }
    end

    it "updates a performance evaluation" do
      put :update, params: params
      expect(assigns(:performance_evaluation).title).to eql("Not so good")
      expect(assigns(:performance_evaluation).employee_id).to eql(other_employee.id)
    end

    it "brings code 200 ok" do
      put :update, params: params
      expect(response.code).to eq('200')
    end

    it "responds the updated performance evaluation" do
      put :update, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eql("Not so good")
      expect(parsed_response["description"]).to eql(performance_evaluation.description)
      expect(parsed_response["employee_id"]).to eql(other_employee.id)
    end

    context "when params are invalid" do
      let(:params) do
        {
          id: performance_evaluation.id,
          title: ""
        }
      end

      it "does not update the performance evaluation" do
        put :update, params: params
        expect(assigns(:performance_evaluation).reload.title).to eql("Good, but not really")
      end

      it "brings code 422" do
        put :update, params: params
        expect(response.code).to eq('422')
      end

      it "responds the errors" do
        put :update, params: params
        parsed_response = JSON.parse(response.body)

        expect(parsed_response["title"]).to include("can't be blank")
      end
    end

    context "when employee setted is from another admin_user" do
        let!(:other_admin_user) { FactoryBot.create(:admin_user) }
        let(:employee) { FactoryBot.create(:employee, admin_user_id: other_admin_user.id) }
        let(:params) do
          {
            id: performance_evaluation.id,
            employee_id: employee.id
          }
        end

        it "responds the errors" do
          put :update, params: params
          parsed_response = JSON.parse(response.body)

          expect(parsed_response["employee_id"]).to include("does not exist")
        end
      end
  end

  describe "#show" do
    let!(:performance_evaluation) do
      FactoryBot.create(:performance_evaluation, title: "Good, but not really", description: "Some long text...", employee: employee)
    end

    let(:params) do
      { id: performance_evaluation.id }
    end

    it "shows a performance evaluation" do
      get :show, params: params
      expect(assigns(:performance_evaluation).id).to eql(performance_evaluation.id)
    end

    it "brings code 200 ok" do
      get :show, params: params
      expect(response.code).to eq('200')
    end

    it "responds the performance evaluation" do
      get :show, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["title"]).to eql("Good, but not really")
      expect(parsed_response["description"]).to eql("Some long text...")
      expect(parsed_response["employee_id"]).to eql(employee.id)
    end
  end

  describe "#destroy" do
    let!(:performance_evaluation) { FactoryBot.create(:performance_evaluation, title: "Good, but not really", employee: employee) }

    let(:params) do
      { id: performance_evaluation.id }
    end

    it "deletes a performance evaluation" do
      expect { delete :destroy, params: params }.to change(PerformanceEvaluation, :count).by(-1)
    end

    it "deletes the correct performance evaluation" do
      delete :destroy, params: params
      expect(assigns(:performance_evaluation).id).to eql(performance_evaluation.id)
    end

    it "brings code 204 No Content" do
      delete :destroy, params: params
      expect(response.code).to eq('204')
    end
  end
end
