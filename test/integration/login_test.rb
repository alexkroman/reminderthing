require 'test_helper'

class LoginTest < ActionController::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "login" do
    visit root_path
    click_link "Login"
    fill_in "email", :with => 'quentin@example.com'
    fill_in "password", :with => 'monkey'
    click_button "Login"
  end
end
