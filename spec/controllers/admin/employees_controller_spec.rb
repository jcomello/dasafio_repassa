require 'rails_helper'

RSpec.describe Admin::EmployeesController, type: :controller do
  let!(:admin_user) { FactoryBot.create(:admin_user) }

  before { api_sign_in(admin_user) }

  describe "#index" do
    let!(:other_admin_user) { FactoryBot.create(:admin_user) }

    let!(:employee1) { FactoryBot.create(:employee, name: "Johnny Lee Hoocker", admin_user_id: admin_user.id) }
    let!(:employee2) { FactoryBot.create(:employee, name: "Johnny Winter", admin_user_id: admin_user.id) }
    let!(:employee3) { FactoryBot.create(:employee, name: "Joe Sebastian", admin_user_id: admin_user.id) }
    let!(:employee_from_other_admin_user) { FactoryBot.create(:employee, name: "Claudio", admin_user_id: other_admin_user.id) }

    it "assigns the employees" do
      get :index
      expect(assigns(:employees)).to contain_exactly(employee1, employee2, employee3)
    end

    it "brings code 200 ok" do
      get :index
      expect(response.code).to eq('200')
    end

    it "responds the employees" do
      get :index
      parsed_response = JSON.parse(response.body).map { |employee_hash| employee_hash["name"] }

      expect(parsed_response).to contain_exactly("Johnny Lee Hoocker", "Johnny Winter", "Joe Sebastian")
    end
  end

  describe "#create" do
    let(:params) do
      { name: "Johnny Winter" }
    end

    it "creates an employee" do
      post :create, params: params
      expect(assigns(:employee)).to be_persisted
    end

    it "brings code 201 created" do
      post :create, params: params
      expect(response.code).to eq('201')
    end

    it "responds the created employee" do
      post :create, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["name"]).to eql("Johnny Winter")
    end

    context "when params are invalid" do
      let(:params) do
        { name: "" }
      end

      it "does not create a employee" do
        post :create, params: params
        expect(assigns(:employee)).not_to be_persisted
      end

      it "brings code 422" do
        post :create, params: params
        expect(response.code).to eq('422')
      end

      it "responds the errors" do
        post :create, params: params
        parsed_response = JSON.parse(response.body)

        expect(parsed_response["name"]).to include("can't be blank")
      end
    end
  end

  describe "#update" do
    let!(:employee) { FactoryBot.create(:employee, name: "Johnny Lee Hoocker", admin_user_id: admin_user.id) }

    let(:params) do
      {
        id: employee.id,
        name: "Johnny Winter"
      }
    end

    it "updates an employee" do
      put :update, params: params
      expect(assigns(:employee).name).to eql("Johnny Winter")
    end

    it "brings code 200 ok" do
      put :update, params: params
      expect(response.code).to eq('200')
    end

    it "responds the updated employee" do
      put :update, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["name"]).to eql("Johnny Winter")
    end

    context "when params are invalid" do
      let(:params) do
        {
          id: employee.id,
          name: ""
        }
      end

      it "does not update a employee" do
        put :update, params: params
        expect(assigns(:employee).name).to eql("Johnny Lee Hoocker")
      end

      it "brings code 422" do
        put :update, params: params
        expect(response.code).to eq('422')
      end

      it "responds the errors" do
        put :update, params: params
        parsed_response = JSON.parse(response.body)

        expect(parsed_response["name"]).to include("can't be blank")
      end
    end

    context "when employee requested belongs to another admin user" do
      let!(:other_admin_user) { FactoryBot.create(:admin_user) }
      let(:params) do
        { id: employee.id }
      end

      before { api_sign_in(other_admin_user) }

      it "brings code 404 not found" do
        put :update, params: params
        expect(response.code).to eq('404')
      end
    end
  end

  describe "#show" do
    let!(:employee) { FactoryBot.create(:employee, name: "Johnny Lee Hoocker", admin_user_id: admin_user.id) }

    let(:params) do
      { id: employee.id }
    end

    it "assigns correct employee" do
      get :show, params: params
      expect(assigns(:employee).id).to eql(employee.id)
    end

    it "brings code 200 ok" do
      get :show, params: params
      expect(response.code).to eq('200')
    end

    it "responds the employee" do
      get :show, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["name"]).to eql("Johnny Lee Hoocker")
    end

    context "when employee requested belongs to another admin user" do
      let!(:other_admin_user) { FactoryBot.create(:admin_user) }
      let(:params) do
        { id: employee.id }
      end

      before { api_sign_in(other_admin_user) }

      it "brings code 404 not found" do
        get :show, params: params
        expect(response.code).to eq('404')
      end
    end
  end

  describe "#destroy" do
    let!(:employee) { FactoryBot.create(:employee, name: "Johnny Lee Hoocker", admin_user_id: admin_user.id) }

    let(:params) do
      { id: employee.id }
    end

    it "deletes an employee" do
      expect { delete :destroy, params: params }.to change(Employee, :count).by(-1)
    end

    it "deletes the correct employee" do
      delete :destroy, params: params
      expect(assigns(:employee).id).to eql(employee.id)
    end

    it "brings code 204 No Content" do
      delete :destroy, params: params
      expect(response.code).to eq('204')
    end

    context "when employee requested belongs to another admin user" do
      let!(:other_admin_user) { FactoryBot.create(:admin_user) }
      let(:params) do
        { id: employee.id }
      end

      before { api_sign_in(other_admin_user) }

      it "brings code 404 not found" do
        delete :destroy, params: params
        expect(response.code).to eq('404')
      end
    end
  end
end
