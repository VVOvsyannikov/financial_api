module Api
  module V1
    class TransfersController < ApplicationController
      def create
        Transfers::InternalTransferService.call(
          sender: @current_user,
          receiver_email: transfer_params[:receiver_email],
          amount: transfer_params[:amount]
        )

        render_success(data: @current_user, serializer: UserSerializer)
      end

      private

      def transfer_params
        params.permit(:receiver_email, :amount)
      end
    end
  end
end
