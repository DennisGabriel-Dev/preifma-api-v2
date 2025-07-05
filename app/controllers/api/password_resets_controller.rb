class Api::PasswordResetsController < ApplicationController
  skip_before_action :authorize

  # POST /api/password_resets
  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_reset_password_token!

      # Gerar URL de reset (você pode ajustar conforme sua frontend)
      reset_url = "#{ENV['FRONTEND_URL']}/reset-password?token=#{user.reset_password_token}"

      # Enviar email
      PasswordResetMailer.reset_password_email(user, reset_url).deliver_now

      render json: {
        message: "Email de recuperação enviado com sucesso!",
        email: user.email
      }, status: :ok
    else
      render json: {
        message: "Email não encontrado em nossa base de dados."
      }, status: :not_found
    end
  end

  # GET /api/password_resets/:token/validate
  def validate_token
    user = User.find_by(reset_password_token: params[:id])
    if user && user.reset_password_token.present? && !user.reset_password_token_expired?
      render json: {
        valid: true,
        email: user.email,
        message: "Token válido"
      }, status: :ok
    else
      render json: {
        valid: false,
        message: "Token inválido ou expirado"
      }, status: :unprocessable_entity
    end
  end

  # PATCH /api/password_resets/:token
  def update
    user = User.find_by(reset_password_token: params[:id])

    if user && user.reset_password_token.present? && !user.reset_password_token_expired?
      if params[:password].present? && params[:password].length >= 6
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]

        if user.save
          user.clear_reset_password_token!
          user.reload
          render json: {
            message: "Senha alterada com sucesso!"
          }, status: :ok
        else
          render json: {
            message: "Erro ao alterar senha",
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        render json: {
          message: "Senha deve ter pelo menos 6 caracteres"
        }, status: :unprocessable_entity
      end
    else
      render json: {
        message: "Token inválido ou expirado"
      }, status: :unprocessable_entity
    end
  end
end
