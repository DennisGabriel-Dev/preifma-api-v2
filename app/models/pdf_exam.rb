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
class PdfExam < ApplicationRecord
  enum :type_pdf, [ :integrated, :subsequent, :concomitant ]

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "type_pdf", "id", "title", "updated_at", "year", "url_jig", "url_exam"]
  end
end
