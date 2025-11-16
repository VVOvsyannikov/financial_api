require 'rails_helper'

RSpec.describe Transfers::InternalTransfer do
  let(:sender) { create(:user, balance: 100) }
  let(:receiver) { create(:user, balance: 0) }

  it "transfers money correctly" do
    result = Transfers::InternalTransfer.new(sender, receiver.id, 50).call

    expect(result[:sender_balance]).to eq("50.0")
    expect(result[:receiver_balance]).to eq("50.0")
    expect(sender.reload.balance.to_s('F')).to eq("50.0")
    expect(receiver.reload.balance.to_s('F')).to eq("50.0")
  end

  context "when receiver_id < sender_id" do
    let!(:receiver) { create(:user, balance: 0) }
    let(:sender) { create(:user, balance: 100) }

    it "transfers money correctly" do
      result = Transfers::InternalTransfer.new(sender, receiver.id, 50).call

      expect(result[:sender_balance]).to eq("50.0")
      expect(result[:receiver_balance]).to eq("50.0")
      expect(sender.reload.balance.to_s('F')).to eq("50.0")
      expect(receiver.reload.balance.to_s('F')).to eq("50.0")
    end
  end

  it "raises error for negative amount" do
    expect { Transfers::InternalTransfer.new(sender, receiver.id, -10).call }.to raise_error("Amount must be positive")
  end

  it "raises error for insufficient balance" do
    expect { Transfers::InternalTransfer.new(sender, receiver.id, 200).call }.to raise_error("Insufficient balance")
  end

  it "raises error if receiver not found" do
    expect { Transfers::InternalTransfer.new(sender, 0, 10).call }.to raise_error("Receiver not found")
  end

  it "raises error if trying to transfer to self" do
    expect { Transfers::InternalTransfer.new(sender, sender.id, 10).call }.to raise_error("Cannot transfer to self")
  end
end
