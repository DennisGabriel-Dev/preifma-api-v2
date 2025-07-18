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
#  type_user              :integer          default(1)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
