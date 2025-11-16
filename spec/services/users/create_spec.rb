require "rails_helper"

RSpec.describe Users::CreateUser do
  subject { described_class.(email: email) }

  context "when valid params" do
    let(:email) { "test@example.com" }

    it "creates a user and returns user + token" do
      expect(subject[:user]).to be_a(User)
      expect(subject[:user].email).to eq(email)
      expect(subject[:token]).to be_present
    end

    it "persists the user" do
      expect { subject }.to change(User, :count).by(1)
    end
  end

  context "when invalid params" do
    let(:email) { "" }

    it "raises ValidationError if email is invalid" do
      expect { subject }.to raise_error(ValidationError)
    end
  end
end
