class PasswordResetMailer < ApplicationMailer
  def reset_password_email(user, reset_url)
    @user = user
    @reset_url = reset_url

    html_content = render_to_string(
      template: 'password_reset_mailer/reset_password_email',
      layout: 'mailer'
    )

    SendgridService.send_email(
      to: @user.email,
      subject: "Recuperação de Senha - Preifma",
      html_content: html_content
    )
  end
end
