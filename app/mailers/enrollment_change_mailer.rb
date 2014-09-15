class EnrollmentChangeMailer < AdminMailer
  def enrollment_change_request(parent, student)
    @user = parent
    @student = student

    mail(
      to: @user.email,
      subject: "Request To Change Enrollment"
    )
  end
end