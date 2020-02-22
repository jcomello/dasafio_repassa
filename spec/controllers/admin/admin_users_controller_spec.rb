require 'rails_helper'

RSpec.describe Admin::AdminUsersController, :type => :controller do
  before { configure_api_headers }

  describe "#create" do
    let(:params) do
      { name: "João Mello" }
    end

    it "creates an admin user" do
      post :create, params: params
      expect(assigns(:admin_user)).to be_persisted
    end

    it "brings code 201 created" do
      post :create, params: params
      expect(response.code).to eq('201')
    end

    it "responds the created admin user" do
      post :create, params: params
      parsed_response = JSON.parse(response.body)

      expect(parsed_response["name"]).to eql("João Mello")
      expect(parsed_response["token"]).to be_present
    end

    context "when params are invalid" do
      let(:params) do
        { name: "" }
      end

      it "does not create an admin user" do
        post :create, params: params
        expect(assigns(:admin_user)).not_to be_persisted
      end

      it "brings code 422 created" do
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
end
