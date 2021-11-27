require 'rails_helper'

RSpec.describe UserSearchQuery do
  describe '.call' do
    let(:user) { create(:user) }
    before do
      create_list(:user, 5)
    end

    %w[full_name email phone_number metadata].each do |column|
      context "when find by #{column}" do
        let(:query) { user.send(column) }
        it { expect(described_class.new(query).call).to match_array([user]) }

        it 'when return empty' do
          expect(described_class.new(Faker::Lorem.characters(number: 10)).call).to be_empty
        end
      end
    end

    %w[key account_key].each do |column|
      context "when find by #{column}" do
        let(:query) { user.send(column) }
        it { expect(described_class.new(query).call).to be_empty }
      end
    end
  end
end
