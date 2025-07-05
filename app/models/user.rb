# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_streak         :integer          default(0)
#  email                  :string
#  last_offensive_at      :datetime
#  name                   :string
#  password               :string
#  password_digest        :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false
  validates :email, uniqueness: true, presence: true
  has_many :user_answers, dependent: :destroy
  has_many :questions

  include OffensiveStreak

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64(32)
    self.reset_password_sent_at = Time.current
    update_columns(
      reset_password_token: reset_password_token,
      reset_password_sent_at: reset_password_sent_at
    )
  end

  def reset_password_token_expired?
    return false if reset_password_sent_at.nil?
    reset_password_sent_at < 1.hour.ago
  end

  def clear_reset_password_token!
    update_columns(
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end
end
