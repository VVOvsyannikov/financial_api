module Users
  class CreateUser
    class << self
      def call(params)
        new(params).call
      end
    end

    def initialize(params)
      @params = params
    end

    def call
      user = User.new(@params)

      unless user.save
        raise ValidationError.new("Validation failed", details: user.errors.full_messages)
      end

      token = JsonWebToken.encode(user_id: user.id)
      { user:, token: }
    end
  end
end
