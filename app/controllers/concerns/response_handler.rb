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

  def render_success(data:, status: :ok)
    render json: data, status:
  end
end
