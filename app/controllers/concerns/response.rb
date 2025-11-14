module Response
  extend ActiveSupport::Concern

  def render_success(data: {}, status: :ok)
    render json: data, status: status
  end

  def render_error(errors, status: :unprocessable_content)
    render json: { errors: Array(errors) }, status: status
  end

  def render_unauthorized
    render_error("Unauthorized", status: :unauthorized)
  end
end
