module AuthorizeRequest
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  private

  def authorize_request
    header = request.headers["Authorization"]&.split(" ")&.last
    decoded = JsonWebToken.decode(header)
    @current_user = User.find(decoded[:user_id])
  rescue
    render_unauthorized
  end
end
