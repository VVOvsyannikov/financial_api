module Users
  class CreateService < ApplicationService
    def initialize(user_params:)
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)

      unless user.save
        raise ValidationError.new("Validation failed", details: user.errors.full_messages)
      end

      [ user, JsonWebToken.encode(user_id: user.id) ]
    end
  end
end
