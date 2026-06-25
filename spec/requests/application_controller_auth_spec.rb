require "rails_helper"

RSpec.describe "ApplicationController auth", type: :request do
  describe "GET /api/pdf_exams" do
    it "rejects request without authorization header" do
      get api_pdf_exams_path

      expect(response).to have_http_status(:unauthorized)
      expect(json["error"]).to eq("Não autorizado")
    end

    it "rejects invalid bearer token" do
      get api_pdf_exams_path, headers: { "Authorization" => "Bearer token-invalido" }

      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects token for missing user" do
      token = JWT.encode({ id: 999_999 }, ENV.fetch("secret_jwt"), "HS256")
      get api_pdf_exams_path, headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects malformed authorization header" do
      get api_pdf_exams_path, headers: { "Authorization" => "TokenSemBearer" }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
