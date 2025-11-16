require 'rails_helper'

RSpec.describe "API::V1::Transfers", type: :request do
  let!(:sender) { create(:user, balance: 100) }
  let!(:receiver) { create(:user, balance: 0) }
  let(:token) { JsonWebToken.encode(user_id: sender.id) }
  let(:auth_headers) do
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  describe "POST /api/v1/transfers" do
    it "transfers money correctly" do
      post "/api/v1/transfers", params: { receiver_email: receiver.email, amount: 50 }.to_json, headers: auth_headers

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)
      expect(data["sender_balance"]).to eq(50.0)
      expect(data["receiver_balance"]).to eq(50.0)
    end

    it "fails if amount is negative" do
      post "/api/v1/transfers", params: { receiver_email: receiver.email, amount: -10 }.to_json, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "fails if insufficient balance" do
      post "/api/v1/transfers", params: { receiver_email: receiver.email, amount: 200 }.to_json, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "fails if trying to transfer to self" do
      post "/api/v1/transfers", params: { receiver_email: sender.id, amount: 10 }.to_json, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
