require "rails_helper"

RSpec.describe "Api::Questions", type: :request do
  let(:user) { users(:one) }
  let(:question) { questions(:one) }

  describe "POST /api/questions/create" do
    it "creates question with nested answers" do
      expect {
        post api_questions_create_path, params: {
          title: "Nova questão",
          description: "Enunciado",
          year: 2025,
          subject: "historia",
          answers_attributes: [
            { text: "A", correct: true },
            { text: "B", correct: false }
          ]
        }, headers: jwt_headers(user)
      }.to change(Question, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["message"]).to eq("Questão criada com sucesso!")
    end

    it "fails with invalid data" do
      post api_questions_create_path, params: { title: "" }, headers: jwt_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/questions/:id" do
    it "returns question" do
      get api_questions_path(question), headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["question"]["id"]).to eq(question.id)
      expect(json["question"]["answers"]).to be_present
    end

    it "returns not found" do
      get api_questions_path(999_999), headers: jwt_headers(user)

      expect(response).to have_http_status(:not_found)
    end

    it "requires authentication" do
      get api_questions_path(question)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/questions/:id" do
    it "updates question" do
      patch api_questions_path(question), params: {
        title: "Título atualizado",
        description: question.description,
        year: question.year,
        subject: question.subject
      }, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(question.reload.title).to eq("Título atualizado")
    end

    it "fails with invalid data" do
      patch api_questions_path(question), params: { title: "" }, headers: jwt_headers(user)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/questions/:id" do
    it "destroys question" do
      temp = Question.create!(
        title: "Temp",
        description: "Temp",
        year: 2025,
        subject: "temp"
      )

      expect {
        delete api_questions_path(temp), headers: jwt_headers(user)
      }.to change(Question, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
