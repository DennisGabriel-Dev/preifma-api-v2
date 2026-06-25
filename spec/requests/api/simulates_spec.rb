require "rails_helper"

RSpec.describe "Api::Simulates", type: :request do
  let(:user) { users(:one) }
  let(:question) { questions(:one) }
  let(:correct_answer) { answers(:one_correct) }
  let(:wrong_answer) { answers(:one_wrong) }

  describe "POST /api/simulates/answer" do
    it "returns correct answer without correct_is" do
      post api_simulates_answer_path, params: {
        question_id: question.id,
        answer_id: correct_answer.id
      }, headers: jwt_headers(user)

      expect(response).to have_http_status(:created)
      expect(json["correct"]).to be true
      expect(json["correct_is"]).to be_nil
    end

    it "returns wrong answer with correct_is" do
      post api_simulates_answer_path, params: {
        question_id: question.id,
        answer_id: wrong_answer.id
      }, headers: jwt_headers(user)

      expect(response).to have_http_status(:created)
      expect(json["correct"]).to be false
      expect(json["correct_is"]).to be_present
    end

    it "returns errors for invalid data" do
      post api_simulates_answer_path, params: {
        question_id: nil,
        answer_id: nil
      }, headers: jwt_headers(user)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/simulates/questions" do
    it "lists registered questions" do
      get api_simulates_questions_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["questions"]).to be_present
    end

    it "returns not found when empty" do
      UserAnswer.delete_all
      Answer.delete_all
      Question.delete_all

      get api_simulates_questions_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:not_found)
    end

    it "supports ransack filter" do
      get api_simulates_questions_path,
          params: { q: { subject_eq: "matematica" } },
          headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["questions"].size).to eq(1)
    end
  end

  describe "GET /api/simulates/questions/:id" do
    it "returns question and answers" do
      get api_simulates_question_path(question), headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["question"]).to be_present
      expect(json["answers"]).to be_present
    end

    it "returns not found" do
      get api_simulates_question_path(999_999), headers: jwt_headers(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/simulates/results" do
    it "returns user answers" do
      get api_simulates_results_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["user_answers"]).to be_present
    end

    it "requires authentication" do
      get api_simulates_results_path

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/simulates/retry_responses" do
    it "returns wrong questions" do
      get api_simulates_retry_responses_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["questions"]).to be_a(Array)
    end
  end
end
