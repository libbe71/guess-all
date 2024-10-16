

class User < ApplicationRecord
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  validates :twitter_id, uniqueness: true, :allow_blank => true, :allow_nil => true

  has_secure_password

  #has many :notifications, as: :recipient
end
