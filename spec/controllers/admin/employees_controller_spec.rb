require 'rails_helper'

RSpec.describe Admin::EmployeesController, type: :controller do
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
    let!(:employee) { FactoryBot.create(:employee, name: "Johnny Lee Hoocker") }

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
  end
end
