require "rails_helper"

RSpec.describe "Api::PdfExams", type: :request do
  let(:user) { users(:one) }
  let(:pdf_exam) { pdf_exams(:one) }

  describe "GET /api/pdf_exams" do
    it "requires authentication" do
      get api_pdf_exams_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns pdf exams" do
      get api_pdf_exams_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json).to be_a(Array)
    end
  end

  describe "GET /api/pdf_exams/:id" do
    it "returns pdf exam" do
      get api_pdf_exam_path(pdf_exam), headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(pdf_exam.id)
    end
  end

  describe "POST /api/pdf_exams" do
    it "creates pdf exam" do
      expect {
        post api_pdf_exams_path, params: {
          pdf_exam: {
            year: 2025,
            type_pdf: "integrated",
            title: "Prova ENEM",
            url_jig: "http://jig.example",
            url_exam: "http://exam.example"
          }
        }, headers: jwt_headers(user)
      }.to change(PdfExam, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /api/pdf_exams/:id" do
    it "updates pdf exam" do
      patch api_pdf_exam_path(pdf_exam), params: {
        pdf_exam: { title: "Título atualizado" }
      }, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(pdf_exam.reload.title).to eq("Título atualizado")
    end
  end

  describe "DELETE /api/pdf_exams/:id" do
    it "destroys pdf exam" do
      expect {
        delete api_pdf_exam_path(pdf_exam), headers: jwt_headers(user)
      }.to change(PdfExam, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
