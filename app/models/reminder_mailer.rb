class ReminderMailer < ActionMailer::Base

  def email(message)
    setup(message)
    @from = 'ReminderThing <sms@alexkroman.com>'
    @subject = "Reminder: #{message.message}"
  end

  def sms(message)
    setup(message)
    @from = 'sms@alexkroman.com'
    @subject = ''
    @body = message.message
  end

  def setup(message)
    @content_type = "text/plain"
    @recipients = message.email
  end

end
