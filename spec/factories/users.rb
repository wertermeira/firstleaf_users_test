FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone_number { 'aaa' }
    full_name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 8, max_length: 12) }
    key { SecureRandom.uuid }
    account_key { SecureRandom.uuid }
    metadata { 'male, age 32, unemployed, college-educated' }
  end
end
