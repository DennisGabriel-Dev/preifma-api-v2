# == Schema Information
#
# Table name: questions
#
#  id            :bigint           not null, primary key
#  description   :text
#  subject       :string
#  title         :string
#  type_question :integer
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
