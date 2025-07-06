class Api::QuestionsController < ApplicationController
  def create
    question = Question.new(questions_params)
    if question.save
      render json: { message: "Questão criada com sucesso!" }, status: :created
      return
    end

    render json: { message: "Ops! Ocorreu um erro ao criar a sua questão!" }, status: :forbidden
  end

  private

  def questions_params
    if params[:image].present? && params[:images].blank?
      params[:images] = [params[:image]]
    end

    params.permit(:title, :description, :year, :subject, answers_attributes: [:text, :correct], images: [])
  end
end
