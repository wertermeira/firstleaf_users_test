namespace :populate do
  include FactoryBot::Syntax::Methods if Rails.env.development?

  desc 'Users'
  task users: :environment do
    create_list(:user, 10).each do |user|
      p user.full_name
    end
  end
end
