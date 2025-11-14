class ApplicationController < ActionController::API
  include Response
  include AuthorizeRequest
end
