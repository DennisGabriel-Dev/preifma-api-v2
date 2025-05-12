# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  year        :integer
#  subject     :string
#

class Question < ApplicationRecord
  validates :title, :description, :year, :subject, presence: true
  has_many :answers, dependent: :destroy
  has_many :user_answers
  accepts_nested_attributes_for :answers

  def correct_answer
    (answers.select { _1.correct? }).first
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "title", "updated_at", "subject", "year", "answers", "user_answers"]
  end
end
