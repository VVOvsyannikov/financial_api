module Users
  class CreateUser
    class << self
      def call(user_params:)
        new(user_params:).call
      end
    end

    def initialize(user_params:)
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)

      unless user.save
        raise ValidationError.new("Validation failed", details: user.errors.full_messages)
      end

      token = JsonWebToken.encode(user_id: user.id)
      { user:, token: }
    end
  end
end
