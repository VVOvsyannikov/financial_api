require 'rails_helper'

RSpec.describe "API::V1::Users", type: :request do
  let(:headers) { {} }

  describe "POST /api/v1/users" do
    it "creates a user and returns a token" do
      post "/api/v1/users", params: { email: "test@example.com" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("token")
    end
  end

  context "with existing user" do
    let!(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }
    let(:auth_headers) { { "Authorization" => "Bearer #{token}" } }
    let(:valid_data) { { "user" => { "email" => user.email, "balance" => user.balance.to_s } } }

    it "returns balance" do
      get "/api/v1/users/balance", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include(valid_data)
    end

    it "deposits money" do
      post "/api/v1/users/deposit", params: { amount: 100 }, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["balance"]).to eq("100.0")
    end

    it "withdraws money" do
      user.update!(balance: 50)
      post "/api/v1/users/withdraw", params: { amount: 30 }, headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["balance"]).to eq("20.0")
    end

    it "cannot withdraw more than balance" do
      post "/api/v1/users/withdraw", params: { amount: 100 }, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
