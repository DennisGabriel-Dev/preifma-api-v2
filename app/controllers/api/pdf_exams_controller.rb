class Api::PdfExamsController < ApplicationController
  before_action :set_pdf_exam, only: [:show, :update, :destroy]

  def index
    @pdf_exams = PdfExam.all
    render json: @pdf_exams
  end

  def show
    render json: @pdf_exam
  end

  def create
    @pdf_exam = PdfExam.new(pdf_exam_params)

    if @pdf_exam.save
      render json: @pdf_exam, status: :created
    else
      render json: { errors: @pdf_exam.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @pdf_exam.update(pdf_exam_params)
      render json: @pdf_exam
    else
      render json: { errors: @pdf_exam.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @pdf_exam.destroy
    head :no_content
  end

  private

  def set_pdf_exam
    @pdf_exam = PdfExam.find(params[:id])
  end

  def pdf_exam_params
    params.require(:pdf_exam).permit(:year, :type_pdf, :title, :url_jig, :url_exam)
  end
end
