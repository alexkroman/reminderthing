# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      old_reminders = Reminder.find_all_by_session_id(session[:csrf_id])
      current_user.give_ownership_of(old_reminders)
      current_user.time_zone = session[:time_zone] if session[:time_zone]
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_to root_path
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_to root_path
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Your email and password didn't match"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
