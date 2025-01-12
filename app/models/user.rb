

class User < ApplicationRecord
  has_many :moves, dependent: :nullify
  
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  validates :twitter_id, uniqueness: true, :allow_blank => true, :allow_nil => true

  has_secure_password

end
