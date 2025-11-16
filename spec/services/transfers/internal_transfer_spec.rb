require 'rails_helper'

RSpec.describe Transfers::InternalTransfer do
  subject { described_class.(sender: sender, receiver_email: receiver.email, amount: amount) }

  let!(:sender) { create(:user, balance: 100) }
  let!(:receiver) { create(:user, balance: 50) }

  context "when valid transfer" do
    let(:amount) { 30 }

    it "transfers funds correctly" do
      subject
      expect(sender.reload.balance.to_f).to eq(70)
      expect(receiver.reload.balance.to_f).to eq(80)
    end
  end

  context "when amount is negative" do
    let(:amount) { -10 }

    it "raises ValidationError" do
      expect { subject }.to raise_error(ValidationError, /Amount must be positive/)
    end
  end

  context "when sender tries to send more than balance" do
    let(:amount) { 200 }

    it "raises NotEnoughFundsError" do
      expect { subject }.to raise_error(NotEnoughFundsError)
    end
  end

  context "when sender tries to send to self" do
    let(:amount) { 10 }

    it "raises ValidationError" do
      expect {
        described_class.(sender: sender, receiver_email: sender.email, amount: amount)
      }.to raise_error(ValidationError, /Cannot transfer to self/)
    end
  end

  context "when receiver does not exist" do
    let(:amount) { 10 }

    it "raises ValidationError" do
      expect {
        described_class.(sender: sender, receiver_email: 0, amount: amount)
      }.to raise_error(ValidationError, /Receiver not found/)
    end
  end
end
