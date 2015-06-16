class NotificationMailer < AdminMailer

  def trial_reminder(opportunity)
    @opportunity = opportunity
    @parent = @opportunity.user

    @parent ? mail(to: @parent.email, subject: 'You have a trial coming up!') : mail(to: @opportunity.parent_email, subject: 'You have a trial coming up!')
  end
end
