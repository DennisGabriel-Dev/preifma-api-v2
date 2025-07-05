class PasswordResetMailer < ApplicationMailer
  def reset_password_email(user, reset_url)
    @user = user
    @reset_url = reset_url

    mail(
      to: @user.email,
      subject: "Recuperação de Senha - Preifma"
    )
  end
end
