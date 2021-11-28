require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[full_name email key account_key phone_number password_digest metadata].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  describe 'when save user' do
    let(:email) { 'Site@Gmail.com' }
    let(:user) { create(:user, email: email) }
    context 'when email downcase' do
      it {  expect(user.email).to eq(email.downcase) }
    end
  end

  describe 'when validation' do
    it { is_expected.to have_secure_password }

    %i[email full_name phone_number].each do |column|
      it { is_expected.to validate_presence_of(column) }
    end

    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(72) }

    it { is_expected.to validate_presence_of(:account_key).on(:update) }

    %i[email full_name].each do |column|
      it { is_expected.to validate_length_of(column).is_at_most(200) }
    end
    %i[account_key key].each do |column|
      it { is_expected.to validate_length_of(column).is_at_most(100) }
    end

    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('userexample.com').for(:email) }

    it { is_expected.to validate_length_of(:phone_number).is_at_most(20) }

    context 'when unique' do
      subject { create(:user) }

      %i[email phone_number key account_key].each do |column|
        it { is_expected.to validate_uniqueness_of(column).case_insensitive }
      end
    end
  end
end
