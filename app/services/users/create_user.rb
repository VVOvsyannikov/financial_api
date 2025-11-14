module Users
  class CreateUser
    def initialize(params)
      @params = params
    end

    def call
      @user = User.new(@params)
      raise StandardError, @user.errors.full_messages.join(", ") unless @user.save

      @token = JsonWebToken.encode(user_id: @user.id)
      { user: @user, token: @token }
    end
  end
end
