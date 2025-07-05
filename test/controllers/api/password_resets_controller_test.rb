require "test_helper"

class Api::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
  end

  test "should create password reset request" do
    assert_emails 1 do
      post api_password_resets_path, params: { email: @user.email }
    end

    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal "Email de recuperação enviado com sucesso!", json_response["message"]
    assert_equal @user.email, json_response["email"]
  end

  test "should return error for non-existent email" do
    post api_password_resets_path, params: { email: "nonexistent@example.com" }

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "Email não encontrado em nossa base de dados.", json_response["message"]
  end

  test "should validate valid token" do
    @user.generate_reset_password_token!
    @user.reload
    get validate_token_api_password_reset_path(@user.reset_password_token)

    assert_response :ok
    json_response = JSON.parse(response.body)
    assert json_response["valid"]
    assert_equal @user.email, json_response["email"]
  end

  test "should reject expired token" do
    @user.generate_reset_password_token!
    @user.update_column(:reset_password_sent_at, 2.hours.ago)
    @user.reload
    get validate_token_api_password_reset_path(@user.reset_password_token)

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_not json_response["valid"]
  end

  test "should update password with valid token" do
    @user.generate_reset_password_token!
    @user.reload
    patch api_password_reset_path(@user.reset_password_token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }

    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal "Senha alterada com sucesso!", json_response["message"]

    @user.reload
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at
  end

  test "should reject password update with expired token" do
    @user.generate_reset_password_token!
    @user.update_column(:reset_password_sent_at, 2.hours.ago)
    @user.reload
    patch api_password_reset_path(@user.reset_password_token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Token inválido ou expirado", json_response["message"]
  end

  test "should reject password update with short password" do
    @user.generate_reset_password_token!
    @user.reload
    patch api_password_reset_path(@user.reset_password_token), params: {
      password: "123",
      password_confirmation: "123"
    }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal "Senha deve ter pelo menos 6 caracteres", json_response["message"]
  end
end
