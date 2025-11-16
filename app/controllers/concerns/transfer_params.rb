module TransferParams
  extend ActiveSupport::Concern

  private

  def transfer_params
    params.permit(:receiver_email, :amount)
  end
end
