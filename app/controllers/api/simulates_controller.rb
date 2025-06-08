class Api::SimulatesController < ApplicationController
  def answer
    user_answer = current_user.user_answers.new(user_answer_params)
    find_before_create_user_answer = UserAnswer.find_by(
      user_id: @current_user.id,
      question_id: user_answer_params[:question_id],
      answer_id: user_answer_params[:answer_id]
    )

    user_answer = find_before_create_user_answer if find_before_create_user_answer.present?

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
    q = Question.includes(:answers).ransack(params[:q])
    all_questions = q.result(distinct: true)

    if all_questions.blank?
      render json: { message: "Nenhuma questão registrada!" }, status: :not_found
      return
    end

    render json: {
      questions: all_questions.as_json(
        only: [:id, :title, :description],
        include: {
          answers: {
            only: [:id, :correct, :text]
          }
        }
      )
    }, status: :ok
  end

  def results = render json: { user_answers: @current_user.user_answers }, status: :ok

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
