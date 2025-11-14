module Api
  module V1
    class TransfersController < ApplicationController
      before_action :authorize_request

      def create
        data = Transfers::InternalTransfer.new(
          @current_user,
          transfer_params[:receiver_id],
          transfer_params[:amount]
        ).call

        render_success(data:)
      rescue StandardError => e
        render_error([ e.message ])
      end

      private

      def transfer_params
        params.permit(:receiver_id, :amount)
      end
    end
  end
end
