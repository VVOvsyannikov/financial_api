module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        data = Users::CreateUser.(user_params)
        render_success(data:, status: :created)
      end

      def balance
        render_success(data: { user: { id: @current_user.id, balance: @current_user.balance } })
      end

      def deposit
        new_balance = Users::Deposit.(@current_user, amount_param)
        render_success(data: { user: { id: @current_user.id, balance: new_balance } })
      end

      def withdraw
        new_balance = Users::Withdraw.(@current_user, amount_param)
        render_success(data: { user: { id: @current_user.id, balance: new_balance } })
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
