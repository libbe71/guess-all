class User < ApplicationRecord
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :birthdate, presence: true
  validates :phone_number, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :state, presence: true
  validates :city, presence: true
  validates :address, presence: true

  has_secure_password
end
