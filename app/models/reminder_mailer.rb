class ReminderMailer < ActionMailer::Base

  def message(message)
    subject = message.message
  end

  private 
  
  def setup
    content_type      "text/plain"
    recipients        message.email
    from              'sms@texttosms.com'
  end

end
