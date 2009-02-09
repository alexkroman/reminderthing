class ReminderMailer < ActionMailer::Base

  def email(message)
    setup(message)
    @from = 'ReminderThing <sms@reminderthing.com>'
    @subject = "Reminder: #{message.message}"
    @content = message.message
  end

  def sms(message)
    setup(message)
    @from = 'sms@reminderthing.com'
    @subject = ''
    @content = message.message
  end

  def setup(message)
    @content_type = "text/plain"
    @recipients = message.email
  end

end
