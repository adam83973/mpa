class EnrollmentChangeMailer < AdminMailer
  def enrollment_change_request(parent, student)
    @user = parent
    @student = student

    mail(
      to: @user.email,
      subject: "Request To Change Enrollment"
    )
  end

  def ecr_received(ecr)
    # Email to be sent when enrollment change request has been received.
    @ecr = ecr
    @student = Student.find(@ecr.student_id)
    @user = User.find(@ecr.user_id)

    mail(
      to: @user.email,
      subject: "Enrollment Change Received!"
    )
  end

  def ecr_processed(ecr)
    # Email to be sent when enrollment change request has been processed.
    @ecr = ecr
    @student = Student.find(@ecr.student_id)
    @user = User.find(@ecr.user_id)

    mail(
      to: @user.email,
      subject: "Enrollment Change Processed!"
    )
  end
end