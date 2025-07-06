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
    q = Question.includes(:answers, images_attachments: :blob).ransack(params[:q])
    all_questions = q.result(distinct: true)

    if all_questions.blank?
      render json: { message: "Nenhuma questão registrada!" }, status: :not_found
      return
    end

    render json: {
      questions: all_questions.as_json(
        only: [:id, :title, :description, :year, :subject],
        methods: [:image_urls],
        include: {
          answers: { only: [:id, :correct, :text] }
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

  def retry_responses
    wrong_questions = @current_user.user_answers.includes(:question)
                        .order(id: :desc)
                        .uniq(&:question_id)
                        .map { _1.question unless _1.correct }
                        .compact
    wrong_questions = [] if wrong_questions.blank?

    render json: {
      questions: wrong_questions.as_json(
        only: [:id, :title, :description],
        include: {
          answers: {
            only: [:id, :correct, :text]
          }
        }
      )
    }, status: :ok
  end

  private

  def user_answer_params
    params.permit(:question_id, :answer_id)
  end
end
