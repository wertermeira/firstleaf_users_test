require 'rails_helper'

RSpec.describe UserAccountKeyService do
  let(:user) { create(:user) }
  let(:account_key) { Faker::Internet.uuid }
  let(:attributes) do
    {
      email: user.email,
      key: user.key
    }
  end
  let(:expected_response) do
    {
      email: user.email,
      account_key: account_key
    }.to_json
  end
  let(:generate_key) { instance_double(GenerateAccountKey) }
  before do
    allow(GenerateAccountKey).to receive(:new).with(attributes).and_return(generate_key)
    allow(generate_key).to receive(:create).and_return(JSON.parse(expected_response))
  end

  describe '.call' do
    context 'when update' do
      it do
        described_class.new(user).call
        expect(user.reload.account_key).to eq(account_key)
      end
    end

    context 'when raise' do
      let(:account_key) { nil }
      it do
        expect { described_class.new(user).call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
