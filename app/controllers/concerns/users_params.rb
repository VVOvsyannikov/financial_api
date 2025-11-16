module UsersParams
  extend ActiveSupport::Concern

  private

  def user_params
    params.permit(:email)
  end

  def amount_param
    params.require(:amount).to_d
  end
end
