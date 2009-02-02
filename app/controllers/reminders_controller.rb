class RemindersController < ApplicationController
  before_filter :set_timezone, :find_reminders, :except => [:send_messages]

  def new
    if session[:reminder]
      @reminder = session[:reminder].clone
      @reminder.phone_number = session[:reminder].phone_number
      @reminder.send_at_date = session[:reminder].send_at_date
      @reminder.send_at_time = session[:reminder].send_at_time
    else
      @reminder = Reminder.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  def create
    @reminder = Reminder.new(params[:reminder])
    if logged_in?
      @reminder.user = current_user
    else
      @reminder.session_id = session[:csrf_id]
    end

    respond_to do |format|
      if @reminder.save
        @reminder.send_at_date = params[:reminder][:send_at_date]
        @reminder.send_at_time = params[:reminder][:send_at_time]
        @reminder.phone_number = params[:reminder][:phone_number]
        session[:reminder] = @reminder
        flash[:notice] = "Your reminder \"#{@reminder.message}\" was scheduled."
        format.html { redirect_to(new_reminder_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    if logged_in?
      @reminder = Reminder.find_by_id_and_user_id(params[:id], current_user.id)
    else
      @reminder = Reminder.find_by_id_and_session_id(params[:id], session[:csrf_id])
    end
    @reminder.destroy
    redirect_to(new_reminder_path)
  end

  def send_messages
    Reminder.find_not_sent.each do |reminder|
      ReminderMailer.deliver_message(reminder) && reminder.sent!
    end
    render :nothing => true
  end

  private

  def set_timezone
    if params[:reminder] and params[:reminder][:time_zone]
      session[:time_zone] = params[:reminder][:time_zone].to_i
    end
    Time.zone = 0 - session[:time_zone].to_i if session[:time_zone]
  end

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
