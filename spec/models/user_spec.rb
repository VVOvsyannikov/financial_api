require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "validations" do
    it "is valid with a valid email" do
      expect(subject).to be_valid
    end

    it "is invalid without email" do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it "is invalid with duplicate email" do
      create(:user, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end
  end

  describe "balance default" do
    it "has default balance 0.0" do
      user = create(:user)
      expect(user.balance).to eq(0.0)
    end
  end
end
