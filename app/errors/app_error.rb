class AppError < StandardError
  attr_reader :status, :details

  def initialize(message, status: :unprocessable_entity, details: nil)
    @status = status
    @details = details
    super(message)
  end
end

class ValidationError < AppError
  def initialize(message, details: nil)
    super(message, status: :unprocessable_entity, details:)
  end
end

class NotEnoughFundsError < AppError
  def initialize(message = "Insufficient balance")
    super(message, status: :unprocessable_entity)
  end
end
