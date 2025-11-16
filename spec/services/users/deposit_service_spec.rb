require 'rails_helper'

RSpec.describe Users::DepositService do
  subject { described_class.(user:, amount:) }

  let(:user) { create(:user, balance: 0) }

  context "when amount is positive" do
    let(:amount) { 100 }

    it "increases balance correctly" do
      expect(subject).to eq(100)
      expect(user.reload.balance).to eq(100)
    end
  end

  context "when amount is negative" do
    let(:amount) { -10 }

    it "raises ValidationError" do
      expect { subject }.to raise_error(ValidationError, /Amount must be positive/)
    end
  end
end
