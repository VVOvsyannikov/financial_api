require "rails_helper"

RSpec.describe Users::CreateService do
  subject { described_class.(user_params: { email: email }) }

  context "when valid params" do
    let(:email) { "test@example.com" }

    it "creates a user and returns user + token" do
      expect(subject.first).to be_a(User)
      expect(subject.first.email).to eq(email)
      expect(subject.last).to be_a(String)
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
