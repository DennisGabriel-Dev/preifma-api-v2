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

class Question < ApplicationRecord
  validates :title, :description, :year, :subject, presence: true
  has_many :answers, dependent: :destroy
  has_many :user_answers
  accepts_nested_attributes_for :answers

  enum :type_question, [ :integrated, :subsequent, :concomitant ]

  has_many_attached :images

  def correct_answer
    (answers.select { _1.correct? }).first
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "type", "title", "updated_at", "subject", "year", "answers", "user_answers"]
  end

  def image_urls
    return [] unless images.attached?

    images.map do |img|
      begin
        Rails.application.routes.url_helpers.rails_blob_url(
          img,
          host: ENV['FRONTEND_URL'],
          protocol: 'https'
        )
      rescue => e
        Rails.logger.error "Erro ao gerar URL da imagem: #{e.message}"
        nil
      end
    end.compact
  end
end
