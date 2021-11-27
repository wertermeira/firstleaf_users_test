class User < ApplicationRecord
  has_secure_password
  default_scope { order(created_at: :desc) }

  validates :email, :full_name, :phone_number, presence: true
  validates :password, length: { in: 6..72 }, allow_blank: true
  validates :password, presence: true, on: :create
  validates :email, :phone_number, :key, :account_key, uniqueness: { case_sensitive: false }
  validates :email, :full_name, length: { maximum: 200 }
  validates :email, email: true, allow_blank: true
  validates :account_key, :key, length: { maximum: 100 }
  validates :phone_number, length: { maximum: 20 }
  validates :account_key, presence: true, on: :update

  before_create :generate_key

  private

  def generate_key
    self.key = loop do
      random_key = SecureRandom.alphanumeric(100)
      break random_key unless User.exists?(key: random_key)
    end
  end
end
