class ApplicationController < ActionController::API
  include ResponseHandler
  include AuthorizeRequest

  rescue_from AppError, with: :render_app_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
end
