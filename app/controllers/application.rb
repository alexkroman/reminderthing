# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include ExceptionNotifiable
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  before_filter :find_reminders

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '27737caff4f7167153688209201ff67c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #

  protected

  def find_reminders
    @reminders = {}
    if logged_in?
      @all_reminders = Reminder.find_owned(current_user)
    else
      @all_reminders = Reminder.find_guest(session[:csrf_id])
    end

    emails = @all_reminders.map{|r| r.email}.uniq.sort
    emails.each do |email|
      @reminders[email] = @all_reminders.select{|r| r.email == email}.group_by(&:send_at_date_display)
    end
  end

end
