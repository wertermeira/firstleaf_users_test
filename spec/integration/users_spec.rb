require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    get 'All users' do
      let(:users_count) { rand(2..10) }
      before do
        create_list(:user, users_count)
      end
      tags 'Users'
      produces 'application/json'

      response 200, 'Success' do
        schema type: :array, items: { '$ref' => '#/components/schemas/user' }
        run_test! do
          expect(json_body.length).to eq(users_count)
        end
      end
    end

    post 'Create user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              full_name: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              metadata: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[full_name email password password_confirmation]
          }
        }
      }

      response 201, 'Created' do
        schema '$ref' => '#/components/schemas/user'
        let(:password) { Faker::Internet.password(min_length: 6, max_length: 72) }
        let(:attributes) do
          {
            user: {
              full_name: Faker::Name.name,
              password: password,
              password_confirmation: password,
              email: Faker::Internet.email,
              phone_number: Faker::PhoneNumber.cell_phone,
              metadata: 'test, test, tes'
            }
          }
        end
        let(:user) { attributes }
        context 'when have enqueued job' do
          ActiveJob::Base.queue_adapter = :test
          run_test! do
            expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
          end
        end
      end

      response 422, 'Unprocessable Entity' do
        let(:password) { Faker::Internet.password(min_length: 6, max_length: 72) }
        let(:attributes) do
          {
            user: {
              full_name: Faker::Name.name,
              password: password,
              email: Faker::Internet.email,
              phone_number: Faker::PhoneNumber.phone_number,
              metadata: 'test, test, tes'
            }
          }
        end
        let(:user) { attributes }
        run_test! do
          expect(json_body.dig('password_confirmation')).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end
  end
end
