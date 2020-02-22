require "rails_helper"

class EmployeeTestsController < Employee::ApplicationController ; end

RSpec.describe Employee::ApplicationController, :type => :controller do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:credentials) { authenticate_with_token("random-token") }

  let!(:employee) { FactoryBot.create(:employee, admin_user_id: admin_user.id, token: "random-token") }

  controller EmployeeTestsController do
    def index
      render json: { message: "Hello world!" }
    end
  end

  before do
    Rails.application.routes.draw do
      get "test", to: "tests#index"
    end
    request.headers.merge!("Authorization" => credentials)
  end

  after do
    Rails.application.reload_routes!
  end

  context "when the user provides a valid api token" do
    it "allows the user to pass" do
      get "index"

      expect(response).to be_successful
      expect(response.body).to eq({ "message" => "Hello world!" }.to_json)
    end
  end

  context "when the user provides an invalid api token" do
    let(:credentials) { authenticate_with_token("other-random-token") }

    it "does not allow to user to pass" do
      get "index"
      expect(response).to be_unauthorized
    end
  end
end
