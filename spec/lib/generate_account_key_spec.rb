require 'rails_helper'

RSpec.describe GenerateAccountKey do
  let(:email) { Faker::Internet.email }
  let(:key) { Faker::Internet.uuid }
  let(:attributes) do
    {
      email: email,
      key: key
    }
  end
  let(:expected_response) do
    {
      email: email,
      account_key: Faker::Internet.uuid
    }.to_json
  end
  let(:base_url) { 'https://account-key-service.herokuapp.com/v1' }
  let(:default_headers) { { 'Content-Type': 'application/json' } }

  describe '.create' do
    context 'when success' do
      before do
        stub_request(:post, "#{base_url}/account")
          .with(headers: default_headers, body: attributes.to_json)
          .to_return(body: expected_response, status: 200, headers: default_headers)
      end

      it do
        expect(described_class.new(attributes).create).to eq(JSON.parse(expected_response))
      end
    end

    context 'when raise status' do
      before do
        stub_request(:post, "#{base_url}/account")
          .with(headers: default_headers, body: attributes.to_json)
          .to_return(body: '', status: 500, headers: default_headers)
      end

      it do
        expect { described_class.new(attributes).create }.to raise_error(ExceptionCode)
      end
    end
  end
end
