require 'rails_helper'
RSpec.describe ConnectionExternal do
  let(:base_url) { 'http://api.domain' }
  let(:headers) { { 'Content-Type': 'application/json' } }
  let(:connection_class) { class_spy(Typhoeus) }

  describe 'when a request' do
    context '#post' do
      it 'delegates the post request' do
        connection_response = instance_double('connection_response', body: JSON.generate('abc': 1), code: 201)
        payload = { user: { name: 'example name' } }
        endpoint = 'me'
        allow(connection_class)
          .to receive(:post)
          .with("#{base_url}/#{endpoint}", headers: headers, body: payload.to_json)
          .and_return(connection_response)

        expc_response = described_class.new(connection_class: connection_class, base_url: base_url)
                                       .post(endpoint: endpoint, payload: payload.to_json)

        expect(expc_response.body).to eq('abc' => 1)
      end
    end
  end
end
