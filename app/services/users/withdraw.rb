module Users
  class Withdraw
    def initialize(user, amount)
      @user = user
      @amount = amount.to_d
    end

    def call
      raise "Amount must be positive" if @amount <= 0

      @user.with_lock do
        raise "Insufficient balance" if @user.balance < @amount
        @user.update!(balance: @user.balance - @amount)
      end
      @user.balance
    end
  end
end
