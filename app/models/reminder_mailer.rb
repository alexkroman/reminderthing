class ReminderMailer < ActionMailer::Base

  def message(message)
    @content_type = "text/plain"
    @recipients = message.email
    @from = 'sms@alexkroman.com'
    @subject = message.message
  end

end
