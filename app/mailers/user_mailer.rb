class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("users.activate.subject")
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
