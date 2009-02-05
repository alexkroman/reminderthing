class RemindersController < ApplicationController

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
        format.html { redirect_to(root_path) }
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

end
