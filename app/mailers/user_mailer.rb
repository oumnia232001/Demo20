class UserMailer < ApplicationMailer
  def test_email(recipient)
    @recipient = recipient
    mail(to: @recipient, from: 'no-reply@votredomaine.com', subject: 'Test Email')
  end
end
