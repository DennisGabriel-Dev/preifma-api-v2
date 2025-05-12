# == Schema Information
#
# Table name: user_answers
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  question_id :integer          not null
#  answer_id   :integer          not null
#  correct     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_answers_on_answer_id    (answer_id)
#  index_user_answers_on_question_id  (question_id)
#  index_user_answers_on_user_id      (user_id)
#

class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer
  before_create :set_correct

  private

  def set_correct
    self.correct = answer.correct
  end
end
