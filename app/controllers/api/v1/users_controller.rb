module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        data = Users::CreateUser.new(user_params).call
        render_success(data:, status: :created)
      rescue StandardError => e
        render_error(e.message, :unprocessable_entity)
      end

      def balance
        render_success(data: { user: { id: @current_user.id, balance: @current_user.balance } })
      end

      def deposit
        balance = Users::Deposit.new(@current_user, amount_param).call.to_s("F")
        render_success(data: { user: { id: @current_user.id, balance: } })
      rescue StandardError => e
        render_error(e.message)
      end

      def withdraw
        result = Users::Withdraw.new(@current_user, amount_param).call
        render_success(data: { user: { id: @current_user.id, balance: result } })
      rescue StandardError => e
        render_error(e.message)
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
