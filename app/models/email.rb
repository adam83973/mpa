class Email < MailForm::Base
  attributes :from_email
  attributes :message
  attributes :subject
  attributes :to_email

  def headers
    {
      :subject => subject,
      :to => to_email,
      :from => %( #{from_email} )
    }
  end
end