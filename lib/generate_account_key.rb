class GenerateAccountKey
  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def create
    response = connection.post(endpoint: 'account', headers: default_headers, payload: attributes.to_json)
    return response.body if response.status == 200

    raise ExceptionCode.new(response.status, response.body)
  end

  private

  def default_headers
    { 'Content-Type': 'application/json' }
  end

  def base_url
    'https://account-key-service.herokuapp.com/v1'
  end

  def connection
    ConnectionExternal.new(base_url: base_url)
  end
end
