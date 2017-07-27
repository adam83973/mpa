class AdminMailer < ActionMailer::Base
  default from: "info@mathplusacademy.com"

  def hold_form(user)
    @user = user
    attachments['hold_form.pdf'] = File.read('app/assets/forms/hold_form.pdf')
    mail(
      subject: "Math Plus Academy - Hold Form",
      to: user.email,
      body: "Please complete attached form and return."
    )

  end

  def termination_form(user)
    @user = user
    attachments['termination_form.pdf'] = File.read('app/assets/forms/termination_form.pdf')
    mail(
      subject: "Math Plus Academy - Termination Form",
      to: user.email,
      body: "Please complete attached form and return."
    )
  end

  def contact_request(user, admin)
    @user = user
    mail(
      subject: "Call this person.",
      to: admin.email
    )
  end
end
