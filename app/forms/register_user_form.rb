class RegisterUserForm
  include ActiveModel::Model

  attr_reader :user
  attr_accessor :email, :password, :password_confirmation, :full_name, :phone_number, :metadata

  validates :email, :full_name, :phone_number, :password, :password_confirmation, presence: true
  validates :password, confirmation: true

  def save
    return false if invalid?

    @user = User.new(user_params)
    user.save!
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.each { |attr, msg| errors.add(attr, msg) }

    false
  end

  private

  def user_params
    { email: email, password: password, full_name: full_name,
      phone_number: phone_number, metadata: metadata }
  end
end
