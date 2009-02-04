# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include ExceptionNotifiable
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  before_filter :set_timezone, :find_reminders, :except => :send_messages

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '27737caff4f7167153688209201ff67c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #

  protected

  def set_timezone
    if params[:reminder] and params[:reminder][:time_zone]
      time_zone = session[:time_zone] = params[:reminder][:time_zone].to_i
      if logged_in?
        current_user.time_zone = time_zone
        current_user.save!
      end
    else
      time_zone = session[:time_zone]
      time_zone = current_user.time_zone if logged_in?
    end
    Time.zone = 0 - time_zone if time_zone
  end

  def find_reminders
    @reminders = {}
    if logged_in?
      @all_reminders = Reminder.find_owned(current_user)
      @emails = Reminder.find(:all, :select => 'distinct(email), count(*) as occurrences', :conditions => ['user_id = ?', current_user.id], :group => 'email', :order => 'occurrences DESC', :limit => 5)
    else
      @all_reminders = Reminder.find_guest(session[:csrf_id])
      @emails = Reminder.find(:all, :select => 'distinct(email), count(*) as occurrences', :conditions => ['session_id = ?', session[csrf_id]], :group => 'email', :order => 'occurrences DESC', :limit => 5)
    end

    @reminders = @all_reminders.group_by(&:send_at_date_display)
  end

end
