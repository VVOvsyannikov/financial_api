module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        data = Users::CreateUser.(user_params:)
        render_success(data:, status: :created)
      end

      def balance
        render_success(data: @current_user, serializer: UserSerializer)
      end

      def deposit
        Users::Deposit.(user: @current_user, amount: amount_param)
        render_success(data: @current_user, serializer: UserSerializer)
      end

      def withdraw
        Users::Withdraw.(user: @current_user, amount: amount_param)
        render_success(data: @current_user, serializer: UserSerializer)
      end

      private

      def user_params
        params.permit(:email)
      end

      def amount_param
        params.require(:amount).to_d
      end
    end
  end
end
