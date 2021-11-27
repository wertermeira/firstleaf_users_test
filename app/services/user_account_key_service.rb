class UserAccountKeyService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def call
    try_create_account_key
  end

  private

  def try_create_account_key
    response = GenerateAccountKey.new(attributes).create
    account_key = response['account_key']
    user.update!(account_key: account_key)
  end

  def attributes
    { email: user.email, key: user.key }
  end
end
