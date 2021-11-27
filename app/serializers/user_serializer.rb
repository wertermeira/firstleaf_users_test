class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :account_key, :key, :phone_number, :metadata
end
