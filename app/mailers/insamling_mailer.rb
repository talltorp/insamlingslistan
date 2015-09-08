class InsamlingMailer < ApplicationMailer
  default from: "info@insamlingslistan.se"

  def send_confirmation_email(insamling)
    @insamling = insamling
    @url = insamling_admin_url(insamling.id, insamling.admin_token)
    mail(to: @insamling.user_email, subject: "Insamling skapad")
  end
end
