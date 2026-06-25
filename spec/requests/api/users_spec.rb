require "rails_helper"

RSpec.describe "Api::Users", type: :request do
  let(:user) { users(:one) }

  describe "POST /api/users/register" do
    it "creates user and returns token" do
      post api_users_register_path, params: {
        user: { email: "novo@example.com", name: "Novo", password: "Senha123" }
      }

      expect(response).to have_http_status(:created)
      expect(json["token"]).to be_present
      expect(json["email"]).to eq("novo@example.com")
    end

    it "rejects duplicate email" do
      post api_users_register_path, params: {
        user: { email: user.email, name: "Dup", password: "Senha123" }
      }

      expect(response).to have_http_status(:bad_request)
      expect(json["message"]).to eq("Usuário já existe!")
    end

    it "rejects invalid password" do
      post api_users_register_path, params: {
        user: { email: "fraco@example.com", name: "Fraco", password: "abc" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to be_present
    end
  end

  describe "POST /api/users/login" do
    it "succeeds with valid credentials" do
      post api_users_login_path, params: {
        user: { email: user.email, password: "Senha123" }
      }

      expect(response).to have_http_status(:ok)
      expect(json["token"]).to be_present
      expect(json["email"]).to eq(user.email)
    end

    it "returns not found for unknown email" do
      post api_users_login_path, params: {
        user: { email: "naoexiste@example.com", password: "Senha123" }
      }

      expect(response).to have_http_status(:not_found)
      expect(json["message"]).to eq("Usuário não existe!")
    end

    it "returns unauthorized for wrong password" do
      post api_users_login_path, params: {
        user: { email: user.email, password: "SenhaErrada" }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/users/data" do
    it "returns profile for authenticated user" do
      get api_users_data_path, headers: jwt_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json["email"]).to eq(user.email)
      expect(json).to have_key("count_user_answers")
    end

    it "requires authentication" do
      get api_users_data_path

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
