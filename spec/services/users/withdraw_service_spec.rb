require 'rails_helper'

RSpec.describe Users::WithdrawService do
  subject { described_class.(user:, amount:) }

  let(:user) { create(:user, balance: 50) }

  context "when amount is positive and <= balance" do
    let(:amount) { 30 }

    it "decreases balance correctly" do
      expect(subject).to eq(20)
      expect(user.reload.balance).to eq(20)
    end
  end

  context "when amount is negative" do
    let(:amount) { -10 }

    it "raises ValidationError" do
      expect { subject }.to raise_error(ValidationError, /Amount must be positive/)
    end
  end

  context "when amount exceeds balance" do
    let(:amount) { 100 }

    it "raises NotEnoughFundsError" do
      expect { subject }.to raise_error(NotEnoughFundsError)
    end
  end
end
