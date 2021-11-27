class ConnectionExternal
  attr_reader :base_url, :connection_class

  def initialize(connection_class: Typhoeus, base_url: nil)
    @connection_class = connection_class
    @base_url = base_url
  end

  def post(endpoint:, payload: '', headers: nil)
    response = connection_class.post(build_url(endpoint),
                                     headers: headers || base_headers, body: payload)

    OpenStruct.new({ status: response.code, body: response.body.present? ? JSON.parse(response.body) : '' })
  end

  private

  def build_url(endpoint)
    "#{base_url}/#{endpoint}"
  end

  def base_headers
    { 'Content-Type': 'application/json' }
  end
end
