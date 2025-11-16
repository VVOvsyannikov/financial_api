module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        data = Users::CreateService.call(user_params:)
        render_success(data:, serializer: UserCreateSerializer, status: :created)
      end

      def balance
        render_success(data: @current_user, serializer: UserSerializer)
      end

      def deposit
        Users::DepositService.call(user: @current_user, amount: amount_param)
        render_success(data: @current_user, serializer: UserSerializer)
      end

      def withdraw
        Users::WithdrawService.call(user: @current_user, amount: amount_param)
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
