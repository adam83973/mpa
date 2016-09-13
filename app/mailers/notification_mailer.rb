class NotificationMailer < AdminMailer
  default from: "info@mathplusacademy.com"

  def badge_request_confirmation(badge_request, parent)
    @badge_request = badge_request
    @parent = parent
    track user: @parent

    mail(to: @parent.email, subject: 'Badge Request Received')
  end

  def badge_request_approval_confirmation(badge_request, parent)
    @badge_request = badge_request
    @parent = parent
    track user: @parent

    mail(to: @parent.email, subject: 'Badge Request Approved')
  end

  def class_restarting_reminder(registration)
    @registration = registration
    @student = @registration.student
    @parent = @student.user
    track user: @parent

    mail(to: @parent.email, subject: 'Your class is restarting') if @parent
  end

  def first_class_reminder(registration)
    @registration = registration
    @student = @registration.student
    @parent = @student.user
    track user: @parent

    mail(to: @parent.email, subject: 'Class Starting Tomorrow') if @parent
  end

  def trial_confirmation(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user
    track user: @parent if @parent

    @parent ? mail(to: @parent.email, subject: "You're trial has been scheduled!") : mail(to: @opportunity.parent_email, subject: "You're trial has been scheduled!")
  end

  def trial_reminder(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user
    track user: @parent if @parent

    @parent ? mail(to: @parent.email, subject: 'You have a trial coming up!') : mail(to: @opportunity.parent_email, subject: 'You have a trial coming up!')
  end

  def trial_attended(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user
    track user: @parent if @parent

    @parent ? mail(to: @parent.email, subject: 'Thank you for attending your trial.') : mail(to: @opportunity.parent_email, subject: 'Thank you for attending your trial.')
  end

  def parent_login_reminder(user)
    @parent = user
    track user: @parent

    mail(to: @parent.email, subject: "You haven't checked your student's progess in a while.")
  end
end
