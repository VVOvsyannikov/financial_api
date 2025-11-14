require 'rails_helper'

RSpec.describe Users::Deposit do
  let(:user) { create(:user, balance: 0) }

  it "increases balance correctly" do
    result = Users::Deposit.new(user, 100).call
    expect(result).to eq(100)
    expect(user.reload.balance).to eq(100)
  end

  it "raises error for negative amount" do
    expect { Users::Deposit.new(user, -10).call }.to raise_error("Amount must be positive")
  end
end
