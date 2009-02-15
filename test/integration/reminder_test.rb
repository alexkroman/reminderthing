require 'test_helper'

class ReminderIntegrationTest < ActionController::IntegrationTest
  fixtures :all

  test "post reminder" do

    visit root_path

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"

    click_link "login"
    fill_in "email", :with => 'quentin@example.com'
    fill_in "password", :with => 'monkey'
    click_button "Login"

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"
  
    click_link "logout"

  end
  
  test "post reminder with a cell phone" do
    visit root_path

    fill_in "reminder_phone_number", :with => '9712357291'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"
  end

  test "post an invalid phone" do
    visit root_path

    fill_in "reminder_phone_number", :with => 'aaaa'
    fill_in "reminder_message", :with => 'test'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"
  end

  test "post an invalid date" do
    visit root_path

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'test'
    fill_in "reminder_send_at_date", :with => 'aaaa'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"
  end

  test "post reminder and then sign up" do

    visit root_path

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"

    click_link "Sign up"

    fill_in "user_email", :with => 'webrat@test.com'
    fill_in "user_password", :with => '123456'
    fill_in "user_password_confirmation", :with => '123456'
    click_button "Sign up"

    click_link "Cancel"

  end

end
