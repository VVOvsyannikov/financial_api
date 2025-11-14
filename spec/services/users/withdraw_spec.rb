require 'rails_helper'

RSpec.describe Users::Withdraw do
  let(:user) { create(:user, balance: 50) }

  it "decreases balance correctly" do
    result = Users::Withdraw.new(user, 30).call
    expect(result).to eq(20)
    expect(user.reload.balance).to eq(20)
  end

  it "raises error if amount is negative" do
    expect { Users::Withdraw.new(user, -10).call }.to raise_error("Amount must be positive")
  end

  it "raises error if insufficient balance" do
    expect { Users::Withdraw.new(user, 100).call }.to raise_error("Insufficient balance")
  end
end
