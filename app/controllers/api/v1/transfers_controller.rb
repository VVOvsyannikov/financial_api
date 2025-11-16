module Api
  module V1
    class TransfersController < ApplicationController
      include TransferParams

      def create
        Transfers::InternalTransfer.(
          sender: @current_user,
          receiver_email: transfer_params[:receiver_email],
          amount: transfer_params[:amount]
        )

        render_success(data: @current_user, serializer: UserSerializer)
      end
    end
  end
end
