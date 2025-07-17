class Api::QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :update, :destroy]

  def create
    question = Question.new(questions_params)
    if question.save
      render json: { message: "Questão criada com sucesso!" }, status: :created
      return
    end

    render json: { message: "Ops! Ocorreu um erro ao criar a sua questão!" }, status: :forbidden
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

  def show
    render json: {
      question: {
        id: @question.id,
        title: @question.title,
        description: @question.description,
        year: @question.year,
        subject: @question.subject,
        type_question: @question.type_question,
        images: @question.image_urls,
        answers: @question.answers.map do |answer|
          {
            id: answer.id,
            text: answer.text,
            correct: answer.correct
          }
        end
      }
    }, status: :ok
  end

  def update
    if @question.update(questions_params)
      render json: { message: "Questão atualizada com sucesso!" }, status: :ok
    else
      render json: { message: "Ops! Ocorreu um erro ao atualizar a questão!" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      render json: { message: "Questão apagada com sucesso!" }, status: :ok
    else
      render json: { message: "Ops! Ocorreu um erro ao apagar a questão!" }, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Questão não encontrada!" }, status: :not_found
  end

  def questions_params
    if params[:image].present? && params[:images].blank?
      params[:images] = [params[:image]]
    end

    params.permit(:title, :description, :year, :subject, :type_question, answers_attributes: [:id, :text, :correct, :_destroy], images: [])
  end
end
