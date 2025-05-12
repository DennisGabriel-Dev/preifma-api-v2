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
      data.merge!(correct_is: correct_answer) unless compare_user_answer

      render json: data, status: :created
    else
      render json: user_answer.errors, status: :unprocessable_entity
    end
  end

  def questions
    q = Question.ransack(params[:q])
    all_questions = q.result(distinct: true)

    all_questions = all_questions.select(:id, :title, :description)
    if all_questions.blank?
      render json: { message: "Nenhuma questão registrada!" }, status: :not_found
      return
    end

    render json: { questions: all_questions.as_json(only: [:id, :title, :description]) }, status: :ok
  end

  def show
    question = Question.find params[:id]
    if question
      render json: { question: , answers: question.answers }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: "Nenhuma questão registrada com id #{params[:id]}!" }, status: :not_found
  end

  private

  def user_answer_params
    params.permit(:question_id, :answer_id)
  end
end
