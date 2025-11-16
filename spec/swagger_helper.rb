require 'rails_helper'

RSpec.configure do |config|
  swagger_doc = {
    openapi: '3.0.1',
    info: {
      title: 'API V1',
      version: 'v1'
    },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: :http,
          scheme: :bearer,
          bearerFormat: :JWT
        }
      }
    },
    security: [],
    paths: {}
  }

  config.openapi_specs = { 'v1/swagger.yaml' => swagger_doc }
  config.swagger_docs   = { 'v1/swagger.yaml' => swagger_doc }
  config.openapi_root = Rails.root.join('swagger').to_s
  config.openapi_format = :yaml
end
