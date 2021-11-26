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
          not_found: {
            type: :object,
            properties: {
              errors: {
                type: :object,
                properties: {
                  status: { type: :integer, example: 404 },
                  message: { type: :string, example: 'not found' }
                }
              }
            }
          },
          setting: {
            type: :object,
            properties: {
              type: { type: :string, example: 'settings' },
              id: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  title: { type: :string, example: Faker::Lorem.sentence },
                  description: { type: :string, example: Faker::Lorem.sentence }
                }
              }
            }
          },
          admin: {
            type: :object,
            properties: {
              type: { type: :string, example: 'admins' },
              id: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'Gusttavo Limma' },
                  email: { type: :string, example: Faker::Internet.email },
                  active: { type: :boolean },
                  created_at: { type: :string, example: Time.current },
                  updated_at: { type: :string, example: Time.current }
                }
              }
            }
          },
          panel: {
            type: :object,
            properties: {
              type: { type: :string, example: 'panels' },
              id: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  active: { type: :boolan },
                  show_price: { type: :boolan },
                  show_call: { type: :boolan },
                  show_variation: { type: :boolan }
                }
              }
            }
          }
        },
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer
          }
        }
      },
      servers: [
        {
          url: 'http://localhost:3000',
          variables: {
            defaultHost: {
              default: 'http://localhost:3000'
            }
          }
        }
      ]
    }
  }
  config.swagger_format = :yaml
end
