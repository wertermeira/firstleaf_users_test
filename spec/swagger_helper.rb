# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          user: {
            type: :object,
            properties: {
              id: { type: :string },
              full_name: { type: :string },
              email: { type: :string },
              account_key: { type: :string, nullable: true },
              key: { type: :string },
              phone_number: { type: :string },
              metadata: { type: :string }
            },
            required: %w[id full_name email key phone_number metadata]
          }
        }
      },
      servers: [
        {
          url: 'http://localhost:3005',
          variables: {
            defaultHost: {
              default: 'http://localhost:3005'
            }
          }
        }
      ]
    }
  }
  config.swagger_format = :yaml
end
