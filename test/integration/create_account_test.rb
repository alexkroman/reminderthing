require 'test_helper'

class CreateAccountTest < ActionController::IntegrationTest
  fixtures :all

  test "should view the login page" do
    visit root_path
    click_link "Sign up now"
    fill_in "user_email", :with => 'webrat@test.com'
    fill_in "user_password", :with => '123456'
    fill_in "user_password_confirmation", :with => '123456'
    click_button "Sign up"
  end

end