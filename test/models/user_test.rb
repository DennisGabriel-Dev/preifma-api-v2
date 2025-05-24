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

require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
