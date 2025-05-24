# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  current_streak    :integer          default(0)
#  email             :string
#  last_offensive_at :datetime
#  name              :string
#  password          :string
#  password_digest   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false
  validates :email, uniqueness: true, presence: true
  has_many :user_answers, dependent: :destroy
  has_many :questions

  include OffensiveStreak
end
