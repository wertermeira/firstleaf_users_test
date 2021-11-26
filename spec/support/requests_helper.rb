module Requests
  module JsonHelpers
    def json_body
      JSON.parse(response.body)
    end

    def json_body_coin
      JSON.parse(File.read("#{Rails.root}/spec/support/fixtures/coin.json"))
    end

    def json_body_coins
      JSON.parse(File.read("#{Rails.root}/spec/support/fixtures/list_coins.json"))
    end
  end
end
