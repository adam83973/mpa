class HoldMailer < AdminMailer
  default from: "info@mathplusacademy.com"
  
  def return_from_hold(student)
    @user = student.user
    @student = student

    mail(
      to: @user.email
    )
  end
end
