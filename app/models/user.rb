class User < ApplicationRecord
  has_secure_password :recovery_password, validations: false
  validates :email, uniqueness: true
end
