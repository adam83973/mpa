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

  def badge_request_confirmation(badge_request, parent)
    @badge_request = badge_request
    @parent = parent

    mail(to: @parent.email, subject: 'Badge request received.')
  end
end
