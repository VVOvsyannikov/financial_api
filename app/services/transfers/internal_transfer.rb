module Transfers
  class InternalTransfer
    def initialize(sender, receiver_id, amount)
      @sender = sender
      @receiver_id = receiver_id
      @amount = amount.to_d
    end

    def call
      receiver = User.find(@receiver_id)

      raise "Amount must be positive" if @amount <= 0
      raise "Cannot transfer to self" if @sender.id == receiver.id

      first, second = [ @sender, receiver ].sort_by(&:id)

      ActiveRecord::Base.transaction do
        first.lock!
        second.lock!

        raise "Insufficient balance" if @sender.balance < @amount

        @sender.update!(balance: @sender.balance - @amount)
        receiver.update!(balance: receiver.balance + @amount)
      end

      { sender_balance: @sender.balance.to_s("F"), receiver_balance: receiver.balance.to_s("F") }
    rescue ActiveRecord::RecordNotFound => e
      raise "Receiver not found"
    end
  end
end
