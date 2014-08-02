class HoldMailer < AdminMailer
  def return_from_hold(student)
    @user = student.user
    @student = student

    mail(
      to: @user.email
    )
  end
end
