class NotificationMailer < AdminMailer

  def trial_confirmation(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user

    @parent ? mail(to: @parent.email, subject: "You're trial has been scheduled!") : mail(to: @opportunity.parent_email, subject: "You're trial has been scheduled!")
  end

  def trial_reminder(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user

    @parent ? mail(to: @parent.email, subject: 'You have a trial coming up!') : mail(to: @opportunity.parent_email, subject: 'You have a trial coming up!')
  end

  def first_class_reminder(registration)
    @registration = registration
    @student = @registration.student
    @parent = @student.user

    mail(to: @parent.email, subject: 'Math Plus - Class Starting') if @parent
  end

  def badge_request_confirmation(badge_request, parent)
    @badge_request = badge_request
    @parent = parent

    mail(to: @parent.email, subject: 'Badge Request Received.')
  end

  def badge_request_approval_confirmation(badge_request, parent)
    @badge_request = badge_request
    @parent = parent

    mail(to: @parent.email, subject: 'Badge Request Approved.')
  end
end
