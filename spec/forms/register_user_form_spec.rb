require 'rails_helper'

RSpec.describe RegisterUserForm, type: :model do
  describe 'when validation' do
    context 'when simple validation' do
      %i[email full_name phone_number password].each do |column|
        it { is_expected.to validate_presence_of(column) }
      end

      it { is_expected.to validate_confirmation_of(:password) }
    end

    context 'when rescue active record invalid' do
      let(:password) { 'xxx' }
      let(:attrs) do
        {
          full_name: Faker::Name.name,
          password: password,
          password_confirmation: password,
          email: Faker::Internet.email,
          phone_number: Faker::PhoneNumber.cell_phone,
          metadata: 'test, test, tes'
        }
      end
      it do
        expect(described_class.new(attrs).save).to be_falsey
      end
    end
  end
end
