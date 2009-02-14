class ReminderMailer < ActionMailer::Base

  def email(message)
    setup(message)
    @from = 'ReminderThing <sms@reminderthing.com>'
    @subject = "Reminder: #{@message}"
    @content = @message
  end

  def sms(message)
    setup(message)
    @from = 'sms@reminderthing.com'
    @subject = ''
    @content = @message
  end

  def setup(message)
    @content_type = "text/plain"
    @recipients = message.email
    @message = message.message
  end

end
