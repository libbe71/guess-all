class User < ApplicationRecord
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true

  has_secure_password
end
