# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :user_answers
  accepts_nested_attributes_for :answers
end
