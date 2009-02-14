class RemindersController < ApplicationController
  before_filter :set_timezone, :only => 'create'

  def guest
  end

  def new
    @reminder = Reminder.new
    @reminder.phone_number = logged_in? ? current_user.phone_number : session[:phone_number]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  def create
    @reminder = Reminder.new(params[:reminder])
    if logged_in?
      @reminder.user = current_user
      current_user.phone_number = @reminder.phone_number
      current_user.save!
    else
      @reminder.session_id = session[:csrf_id]
      session[:phone_number] = @reminder.phone_number
    end

    respond_to do |format|
      if @reminder.save
        format.html do
          if logged_in?
            redirect_to(root_path) 
          else
            redirect_to guest_reminders_path
          end
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @reminder = Reminder.find_by_id_and_user_id(params[:id], current_user.id)
    @reminder.destroy
    redirect_to(root_path)
  end

  def send_messages
    Reminder.find_not_sent.each do |reminder|
      if reminder.sms?
        ReminderMailer.deliver_sms(reminder)
      else
        ReminderMailer.deliver_email(reminder) 
      end && reminder.sent!
    end
    render :nothing => true
  end

  private

  def set_timezone
    @time_zone = session[:time_zone] = params[:reminder][:time_zone].to_i
    current_user.time_zone = @time_zone and current_user.save! and find_timezone if logged_in?
  end

end
