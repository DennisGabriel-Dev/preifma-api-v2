# == Schema Information
#
# Table name: pdf_exams
#
#  id         :bigint           not null, primary key
#  title      :string
#  type_pdf   :integer
#  url_exam   :string
#  url_jig    :string
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PdfExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
