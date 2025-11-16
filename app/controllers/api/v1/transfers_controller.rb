module Api
  module V1
    class TransfersController < ApplicationController
      before_action :authorize_request

      def create
        data = Transfers::InternalTransfer.(
          sender: @current_user,
          receiver_id: transfer_params[:receiver_id],
          amount: transfer_params[:amount]
        )

        render_success(data:)
      end

      private

      def transfer_params
        params.permit(:receiver_id, :amount)
      end
    end
  end
end
