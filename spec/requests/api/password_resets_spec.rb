require "rails_helper"

RSpec.describe "Api::PasswordResets", type: :request do
  let(:user) { users(:one) }

  describe "POST /api/password_resets" do
    it "creates password reset request" do
      allow(SendgridService).to receive(:send_email).and_return(true)

      post api_password_resets_path, params: { email: user.email }

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("Email de recuperação enviado com sucesso!")
      expect(json["email"]).to eq(user.email)
    end

    it "returns error for non-existent email" do
      post api_password_resets_path, params: { email: "nonexistent@example.com" }

      expect(response).to have_http_status(:not_found)
      expect(json["message"]).to eq("Email não encontrado em nossa base de dados.")
    end
  end

  describe "GET /api/password_resets/:id/validate_token" do
    it "validates valid token" do
      user.generate_reset_password_token!
      get validate_token_api_password_reset_path(user.reload.reset_password_token)

      expect(response).to have_http_status(:ok)
      expect(json["valid"]).to be true
      expect(json["email"]).to eq(user.email)
    end

    it "rejects invalid token" do
      get validate_token_api_password_reset_path("token-invalido")

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["valid"]).to be false
    end

    it "rejects expired token" do
      user.generate_reset_password_token!
      user.update_column(:reset_password_sent_at, 2.hours.ago)

      get validate_token_api_password_reset_path(user.reload.reset_password_token)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["valid"]).to be false
    end
  end

  describe "PATCH /api/password_resets/:id" do
    it "updates password with valid token" do
      user.generate_reset_password_token!
      patch api_password_reset_path(user.reload.reset_password_token), params: {
        password: "NovaSenha123",
        password_confirmation: "NovaSenha123"
      }

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("Senha alterada com sucesso!")
      expect(user.reload.reset_password_token).to be_nil
    end

    it "rejects expired token" do
      user.generate_reset_password_token!
      user.update_column(:reset_password_sent_at, 2.hours.ago)

      patch api_password_reset_path(user.reload.reset_password_token), params: {
        password: "NovaSenha123",
        password_confirmation: "NovaSenha123"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["message"]).to eq("Token inválido ou expirado")
    end

    it "rejects short password" do
      user.generate_reset_password_token!
      patch api_password_reset_path(user.reload.reset_password_token), params: {
        password: "123",
        password_confirmation: "123"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["message"]).to eq("Senha deve ter pelo menos 6 caracteres")
    end

    it "rejects password that fails user validation" do
      user.generate_reset_password_token!
      patch api_password_reset_path(user.reload.reset_password_token), params: {
        password: "abcdefgh",
        password_confirmation: "abcdefgh"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["message"]).to eq("Erro ao alterar senha")
      expect(json["errors"]).to be_present
    end
  end
end
