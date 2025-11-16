module Transfers
  class InternalTransfer
    class << self
      def call(sender:, receiver_email:, amount:)
        new(sender:, receiver_email:, amount:).call
      end
    end

    def initialize(sender:, receiver_email:, amount:)
      @sender = sender
      @receiver_email = receiver_email
      @amount = amount.to_d
    end

    def call
      validate_amount
      receiver = load_receiver
      validate_not_self(receiver)
      transfer_funds(receiver)
    end

    private

    def validate_amount
      raise ValidationError, "Amount must be positive" if @amount <= 0
    end

    def load_receiver
      receiver = User.find_by(email: @receiver_email)
      raise ValidationError, "Receiver not found" unless receiver

      receiver
    end

    def validate_not_self(receiver)
      raise ValidationError, "Cannot transfer to self" if @sender.id == receiver.id
    end

    def transfer_funds(receiver)
      first, second = [ @sender, receiver ].sort_by(&:id)

      ActiveRecord::Base.transaction do
        first.lock!
        second.lock!

        raise NotEnoughFundsError if @sender.balance < @amount

        @sender.update!(balance: @sender.balance - @amount)
        receiver.update!(balance: receiver.balance + @amount)
      end
    end
  end
end
