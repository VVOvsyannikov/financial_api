module Users
  class Deposit
    class << self
      def call(user:, amount:)
        new(user:, amount:).call
      end
    end

    def initialize(user:, amount:)
      @user = user
      @amount = amount.to_d
    end

    def call
      raise ValidationError, "Amount must be positive" if @amount <= 0

      @user.with_lock do
        @user.update!(balance: @user.balance + @amount)
      end

      @user.balance
    end
  end
end
