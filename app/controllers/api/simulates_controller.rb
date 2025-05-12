class Api::SimulatesController < ApplicationController
  def answer
    user_answer = current_user.user_answers.new(user_answer_params)
    if user_answer.save
      correct_answer = user_answer.question.correct_answer
      compare_user_answer = correct_answer.id == user_answer.answer_id
      data = {
        question_id: user_answer.question_id,
        answer_id: user_answer.answer_id,
        correct: compare_user_answer
      }

      unless compare_user_answer
       data.merge!(correct_is: correct_answer)
      end
      render json: data, status: :created
    else
      render json: user_answer.errors, status: :unprocessable_entity
    end
  end

  private

  def user_answer_params
    params.permit(:question_id, :answer_id)
  end
end
