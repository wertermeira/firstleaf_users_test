class ExceptionCode < StandardError
  attr_accessor :code

  def initialize(code, message = nil)
    super(message)
    @code = code
  end
end
