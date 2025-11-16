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

  def render_success(data:, status: :ok, serializer: nil, params: {})
    if serializer
      hash = serializer.new(data, params: params).serializable_hash

      if hash[:data].is_a?(Array)
        serialized = hash[:data].map { |d| d[:attributes] }
      else
        serialized = hash[:data]&.[](:attributes)
      end

      render json: { user: serialized }.compact, status: status
    else
      render json: data, status: status
    end
  end

  def render_unauthorized(message = "Not authorized")
    render json: { error: message }, status: :unauthorized
  end
end
