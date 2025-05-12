# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password        :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#

class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false
  validates :email, uniqueness: true, presence: true
  has_many :user_answers
  has_many :questions
end
