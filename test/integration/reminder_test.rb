require 'test_helper'

class ReminderTest < ActionController::IntegrationTest
  fixtures :all

  test "post reminder" do

    visit root_path

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"

    click_link "Login"
    fill_in "email", :with => 'quentin@example.com'
    fill_in "password", :with => 'monkey'
    click_button "Login"

    fill_in "reminder_phone_number", :with => 'test@test.com'
    fill_in "reminder_message", :with => 'please remind me'
    fill_in "reminder_send_at_date", :with => 'May 1, 2009'
    fill_in "reminder_send_at_time", :with => '1:23am'  
    click_button "Schedule"
  end

end
