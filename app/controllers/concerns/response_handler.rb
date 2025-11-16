module ResponseHandler
  extend ActiveSupport::Concern

  private

  def render_app_error(error)
    render json: {
      error: error.message,
      details: error.details
    }, status: error.status
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def render_success(data:, status: :ok, serializer: nil)
    if serializer
      render json: data, serializer: serializer, status: status
    else
      render json: data, status: status
    end
  end

  def render_unauthorized(message = "Not authorized")
    render json: { error: message }, status: :unauthorized
  end
end
