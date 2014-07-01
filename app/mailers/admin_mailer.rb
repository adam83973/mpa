class AdminMailer < ActionMailer::Base
  default from: "info@mathplusacademy.com"

  def return_from_hold(student)
    @user = student.user
    @student = student

    mail(
      to: @user.email
    )
  end

  def issue_submission_notification(issue)
    @issue = issue
    @user = User.find(issue.user_id)
    mail(
      to: @user.email
    )
  end

  def issue_notification(issue)
    @issue = issue
    @user = User.find(issue.user_id)
    mail(
      to: "director@mathplusacademy.com"
    )
  end

  def issue_closed_notification(issue)
    @issue = issue
    @user = User.find(issue.user_id)
    mail(
      to: @user.email
    )
  end
end
