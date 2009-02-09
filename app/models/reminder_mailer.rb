class ReminderMailer < ActionMailer::Base

  def email(message)
    setup(message)
    @from = 'ReminderThing <sms@reminderthing.com>'
    @subject = "Reminder: #{message.message}"
  end

  def sms(message)
    setup(message)
    @from = 'sms@reminderthing.com.com'
    @subject = ''
  end

  def setup(message)
    @content_type = "text/plain"
    @recipients = message.email
    @body = message.message
  end

end
