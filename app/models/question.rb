# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  description :text
#  subject     :string
#  title       :string
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Question < ApplicationRecord
  validates :title, :description, :year, :subject, presence: true
  has_many :answers, dependent: :destroy
  has_many :user_answers
  accepts_nested_attributes_for :answers

  has_many_attached :images

  def correct_answer
    (answers.select { _1.correct? }).first
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "title", "updated_at", "subject", "year", "answers", "user_answers"]
  end

  def image_urls
    return [] unless images.attached?

    images.map do |img|
      Rails.application.routes.url_helpers.rails_blob_path(img)
    end
  end
end
